#[*****************************************************************
  * Arturo
  * 
  * Programming Language + Interpreter
  * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
  *
  * @file: core/statement.nim
  *****************************************************************]#

#[----------------------------------------
    Statement Object
  ----------------------------------------]#

##---------------------------
## Constructors
##---------------------------

proc statementFromCommand(i: cint, xl: ExpressionList, l: cint): Statement {.exportc.} =
    result = Statement(kind: commandStatement, code: i, arguments: xl, pos: l)

proc statementFromCall(i: cstring, xl: ExpressionList, l: cint=0): Statement {.exportc.} =
    result = Statement(kind: callStatement, id: storeOrGetHash(i), expressions: xl, pos: l) 

proc statementFromCallWithKeypath(k: KeyPath, xl: ExpressionList, l: cint=0): Statement {.exportc.} =
    var lst = newExpressionList(@[
        expressionFromArgument(argumentFromKeypath(k)),
        expressionFromArgument(argumentFromArrayLiteral(xl))
    ])
    
    result = statementFromCommand(EXEC_CMD,lst,l)

proc statementFromAssignment(i: cstring, st: Statement, l: cint): Statement {.exportc.} =
    result = Statement(kind: assignmentStatement, symbol: storeOrGetHash(i), rValue: st, pos: l)

proc statementFromAssignmentWithKeypath(k: KeyPath, st: Statement, l: cint=0): Statement {.exportc.} =
    var parentExpr = expressionFromKeyPathPart(k.parts[0], true)

    var i = 1
    while i<k.parts.len-1:
        var exprB = expressionFromKeyPathPart(k.parts[i], false)
        var lst = newExpressionList(@[parentExpr,exprB])

        parentExpr = expressionFromArgument(argumentFromCommand(GET_CMD,lst))
        inc(i)
    
    var keyExpr = expressionFromKeyPathPart(k.parts[^1],false)
    var lst = newExpressionList(@[parentExpr,keyExpr, expressionFromArgument(argumentFromInlineCallLiteral(st))])

    result = statementFromCommand(SET_CMD,lst,l)

proc statementFromExpression(x: Expression, l: cint=0): Statement {.exportc.} =
    result = Statement(kind: expressionStatement, expression: x, pos: l)

proc statementByAddingImplication(st: Statement, i: Statement): Statement {.exportc.} =
    let e = expressionFromArgument(argumentFromFunctionLiteral(newStatementListWithStatement(i)))
    case st.kind
        of callStatement: 
            st.arguments.list.add(e)
        of commandStatement: 
            st.expressions.list.add(e)
        else: discard
        
    result = st

##---------------------------
## Methods
##---------------------------

proc execute(stm: Statement, parent: Value = 0): Value {.inline.} = 
    ## Execute given statement and return result
    ## parent = means statement is in a dictionary context

    StatementLine = stm.pos

    case stm.kind
        of commandStatement:
            # System function calls

            let sf = SystemFunctions[stm.code]
            result = sf.call(sf,stm.arguments)

        of callStatement:
            # User function calls

            let sym = getSymbol(stm.id)
            if sym==0: SymbolNotFoundError($(stm.id))
            else: 
                if sym.kind==FV:
                    result = FN(sym).execute(stm.expressions)
                else: 
                    FunctionNotFoundError($(stm.id))

        of assignmentStatement:
            # Assignments

            result = stm.rValue.execute()
            if parent==0:
                if result.kind==FV: setFunctionName(FN(result),$(stm.symbol))   
                discard setSymbol(stm.symbol, result)
            else:
                D(parent).updateOrSet(stm.symbol, result)
                if result.kind==FV:
                    FN(result).parentThis = result
                    FN(result).parentContext = D(parent)#.d   

        of expressionStatement:
            # Simple expression statements

            result = stm.expression.evaluate()
            