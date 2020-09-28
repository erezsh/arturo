######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: vm/value.nim
######################################################

#=======================================
# Libraries
#=======================================

import hashes, sequtils, strformat, strutils, sugar, tables, times

import utils

#=======================================
# Types
#=======================================

type
    ValueArray* = seq[Value]
    ValueDict*  = OrderedTable[string,Value]

    ByteArray*  = seq[byte]

    SymbolKind* = enum
        thickarrowleft  # <=
        thickarrowright # =>
        arrowleft       # <-
        arrowright      # ->
        doublearrowleft # <<
        doublearrowright# >>

        equalless       # =<
        greaterequal    # >=
        lessgreater     # <>

        tilde           # ~
        backtick        # `
        exclamation     # !
        at              # @
        sharp           # #
        dollar          # $
        percent         # %
        caret           # ^
        ampersand       # &
        asterisk        # *
        minus           # -
        doubleminus     # --
        underscore      # _
        equal           # =
        plus            # +
        doubleplus      # ++

        lessthan        # <
        greaterthan     # >
        
        slash           # /
        doubleslash     # //
        backslash       #
        doublebackslash #
        pipe            # |     

        leftcurly       # {
        rightcurly      # }   

        ellipsis        # ..
        colon           # :

    ValueKind* = enum
        Null        = 0
        Boolean     = 1
        Integer     = 2
        Floating    = 3
        Type        = 4
        Char        = 5
        String      = 6
        Word        = 7
        Literal     = 8
        Label       = 9
        Attr        = 10
        AttrLabel   = 11
        Path        = 12
        PathLabel   = 13
        Symbol      = 14
        Date        = 15
        Binary      = 16
        Array       = 17
        Dictionary  = 18
        Function    = 19
        Inline      = 20
        Block       = 21
        Any         = 22

    Value* {.acyclic.} = ref object 
        case kind*: ValueKind:
            of Null:        discard 
            of Any:         discard
            of Boolean:     b*  : bool
            of Integer:     i*  : int
            of Floating:    f*  : float
            of Type:        t*  : ValueKind
            of Char:        c*  : char
            of String,
               Word,
               Literal,
               Label:       s*  : string
            of Attr,
               AttrLabel:   r*  : string
            of Path,
               PathLabel:   p*  : ValueArray
            of Symbol:      m*  : SymbolKind
            of Date:        
                e*     : ValueDict         
                eobj*  : DateTime
            of Binary:      n*  : ByteArray
            of Array,      
               Inline,
               Block:       a*  : ValueArray
            of Dictionary:  d*  : ValueDict
            of Function:    
                params* : Value         
                main*   : Value

#=======================================
# Constant Values
#=======================================

let I0*  = Value(kind: Integer, i: 0)
let I1*  = Value(kind: Integer, i: 1)
let I2*  = Value(kind: Integer, i: 2)
let I3*  = Value(kind: Integer, i: 3)
let I4*  = Value(kind: Integer, i: 4)
let I5*  = Value(kind: Integer, i: 5)
let I6*  = Value(kind: Integer, i: 6)
let I7*  = Value(kind: Integer, i: 7)
let I8*  = Value(kind: Integer, i: 8)
let I9*  = Value(kind: Integer, i: 9)
let I10* = Value(kind: Integer, i: 10)

let F0*  = Value(kind: Floating, f: 0.0)
let F1*  = Value(kind: Floating, f: 1.0)

let VTRUE*  = Value(kind: Boolean, b: true)
let VFALSE* = Value(kind: Boolean, b: false)

let VNULL* = Value(kind: Null)

#=======================================
# Constructors
#=======================================

## forward declarations
proc newDictionary*(d: ValueDict = initOrderedTable[string,Value]()): Value {.inline.}

proc newNull*(): Value {.inline.} =
    VNULL

proc newBoolean*(b: bool): Value {.inline.} =
    if b: VTRUE
    else: VFALSE

proc newInteger*(i: int): Value {.inline.} =
    if i in 0..10:
        case i:
            of 0: result = I0
            of 1: result = I1
            of 2: result = I2
            of 3: result = I3
            of 4: result = I4
            of 5: result = I5
            of 6: result = I6
            of 7: result = I7
            of 8: result = I8
            of 9: result = I9
            of 10: result = I10
            else: discard # shouldn't reach here
    else:
        result = Value(kind: Integer, i: i)

proc newInteger*(i: string): Value {.inline.} =
    newInteger(parseInt(i))

proc newFloating*(f: float): Value {.inline.} =
    Value(kind: Floating, f: f)

proc newFloating*(f: string): Value {.inline.} =
    newFloating(parseFloat(f))

proc newType*(t: ValueKind): Value {.inline.} =
    Value(kind: Type, t: t)

proc newType*(t: string): Value {.inline.} =
    newType(parseEnum[ValueKind](t.capitalizeAscii()))

proc newChar*(c: char): Value {.inline.} =
    Value(kind: Char, c: c)

proc newString*(s: string, strip: bool = false): Value {.inline.} =
    if not strip:
        Value(kind: String, s: s)
    else:
        Value(kind: String, s: s.strip().split("\n").map((x)=>x.strip).join("\n"))

proc newWord*(w: string): Value {.inline.} =
    Value(kind: Word, s: w)

proc newLiteral*(l: string): Value {.inline.} =
    Value(kind: Literal, s: l)

proc newLabel*(l: string): Value {.inline.} =
    Value(kind: Label, s: l)

proc newAttr*(a: string): Value {.inline.} =
    Value(kind: Attr, r: a)

proc newAttrLabel*(a: string): Value {.inline.} =
    Value(kind: AttrLabel, r: a)

proc newPath*(p: ValueArray): Value {.inline.} =
    Value(kind: Path, p: p)

proc newPathLabel*(p: ValueArray): Value {.inline.} =
    Value(kind: PathLabel, p: p)

proc newSymbol*(m: SymbolKind): Value {.inline.} =
    Value(kind: Symbol, m: m)

proc newSymbol*(m: string): Value {.inline.} =
    newSymbol(parseEnum[SymbolKind](m))

proc newDate*(dt: DateTime): Value {.inline.} =
    let edict = {
        "hour"      : newInteger(dt.hour),
        "minute"    : newInteger(dt.minute),
        "second"    : newInteger(dt.second),
        "nanosecond": newInteger(dt.nanosecond),
        "day"       : newInteger(dt.monthday),
        "Day"       : newString($(dt.weekday)),
        "month"     : newInteger(ord(dt.month)),
        "Month"     : newString($(dt.month)),
        "year"      : newInteger(dt.year),
        "utc"       : newInteger(dt.utcOffset)
    }.toOrderedTable
    Value(kind: Date, e: edict, eobj: dt)

proc newBinary*(n: ByteArray = @[]): Value {.inline.} =
    Value(kind: Binary, n: n)

proc newArray*(a: ValueArray = @[]): Value {.inline.} =
    Value(kind: Array, a: a)

proc newStringArray*(a: seq[string]): Value {.inline.} =
    newArray(a.map(proc (x:string):Value = newString($x)))

proc newDictionary*(d: ValueDict = initOrderedTable[string,Value]()): Value {.inline.} =
    Value(kind: Dictionary, d: d)

proc newFunction*(params: Value, main: Value): Value {.inline.} =
    Value(kind: Function, params: params, main: main)

proc newInline*(a: ValueArray = @[]): Value {.inline.} = 
    Value(kind: Inline, a: a)

proc newBlock*(a: ValueArray = @[]): Value {.inline.} =
    Value(kind: Block, a: a)

proc newStringBlock*(a: seq[string]): Value {.inline.} =
    newBlock(a.map(proc (x:string):Value = newString($x)))

proc copyValue*(v: Value): Value {.inline.} =
    case v.kind:
        of Null:        result = VNULL
        of Boolean:     result = newBoolean(v.b)
        of Integer:     result = newInteger(v.i)
        of Floating:    result = newFloating(v.f)
        of Type:        result = newType(v.t)
        of Char:        result = newChar(v.c)

        of String:      result = newString(v.s)
        of Word:        result = newWord(v.s)
        of Literal:     result = newLiteral(v.s)
        of Label:       result = newLabel(v.s)

        of Attr:        result = newAttr(v.r)
        of AttrLabel:   result = newAttrLabel(v.r)

        of Path:        result = newPath(v.p)
        of PathLabel:   result = newPathLabel(v.p)

        of Symbol:      result = newSymbol(v.m)
        of Date:        result = newDate(v.eobj)
        of Binary:      result = newBinary(v.n)

        of Array:       result = newArray(v.a)
        of Inline:      result = newInline(v.a)
        of Block:       result = newBlock(v.a)

        of Dictionary:  result = newDictionary(v.d)

        of Function:    result = newFunction(v.params, v.main)
        else: discard

#=======================================
# Methods
#=======================================

proc addChild*(parent: Value, child: Value) {.inline.} =
    parent.a.add(child)

#=======================================
# Overloads
#=======================================

proc `==`*(x: Value, y: Value): bool =
    if x.kind in [Integer, Floating] and y.kind in [Integer, Floating]:
        if x.kind==Integer:
            if y.kind==Integer: return x.i==y.i
            else: return (float)(x.i)==y.f
        else:
            if y.kind==Integer: return x.f==(float)(y.i)
            else: return x.f==y.f
    else:
        if x.kind != y.kind: return false

        case x.kind:
            of Null: return true
            of Boolean: return x.b == y.b
            of Type: return x.t == y.t
            of Char: return x.c == y.c
            of String,
               Word,
               Label,
               Literal: return x.s == y.s
            of Attr,
               AttrLabel: return x.r == y.r
            of Symbol: return x.m == y.m
            of Array,
               Inline,
               Block:
                if x.a.len != y.a.len: return false

                for i,child in x.a:
                    if not (child==y.a[i]): return false

                return true
            of Dictionary:
                if x.d.len != y.d.len: return false

                for k,v in pairs(x.d):
                    if not y.d.hasKey(k): return false
                    if not (v==y.d[k]): return false

                return true
            else:
                return false

proc `<`*(x: Value, y: Value): bool =
    if x.kind in [Integer, Floating] and y.kind in [Integer, Floating]:
        if x.kind==Integer:
            if y.kind==Integer: return x.i<y.i
            else: return (float)(x.i)<y.f
        else:
            if y.kind==Integer: return x.f<(float)(y.i)
            else: return x.f<y.f
    else:
        case x.kind:
            of Null: return false
            of Boolean: return false
            of Type: return false
            of Char: return x.c < y.c
            of String,
               Word,
               Label,
               Literal: return x.s < y.s
            of Symbol: return false
            of Array,
               Inline,
               Block:
                return x.a.len < y.a.len
            else:
                return false

proc `>`*(x: Value, y: Value): bool =
    if x.kind in [Integer, Floating] and y.kind in [Integer, Floating]:
        if x.kind==Integer:
            if y.kind==Integer: return x.i>y.i
            else: return (float)(x.i)>y.f
        else:
            if y.kind==Integer: return x.f>(float)(y.i)
            else: return x.f>y.f
    else:
        case x.kind:
            of Null: return false
            of Boolean: return false
            of Type: return false
            of Char: return x.c > y.c
            of String,
               Word,
               Label,
               Literal: return x.s > y.s
            of Symbol: return false
            of Array,
               Inline,
               Block:
                return x.a.len > y.a.len
            else:
                return false

proc `<=`*(x: Value, y: Value): bool =
    x < y or x == y

proc `>=`*(x: Value, y: Value): bool =
    x > y or x == y

proc `!=`*(x: Value, y: Value): bool =
    not (x == y)

#=======================================
# Inspection
#=======================================

proc `$`*(v: Value): string {.inline.} =
    case v.kind:
        of Null         : return "null"
        of Boolean      : return $(v.b)
        of Integer      : return $(v.i)
        of Floating     : return $(v.f)
        of Type         : return ":" & ($v.t).toLowerAscii()
        of Char         : return $(v.c)
        of String,
           Word, 
           Literal,
           Label        : return v.s
        of Attr,
           AttrLabel    : return v.r
        of Path,
           PathLabel    :
            result = v.p.map((x) => $(x)).join("\\")
        of Symbol       :
            case v.m:
                of thickarrowleft   : return "<="
                of thickarrowright  : return "=>"
                of arrowleft        : return "<-"
                of arrowright       : return "->"
                of doublearrowleft  : return "<<"
                of doublearrowright : return ">>"

                of equalless        : return "=<"
                of greaterequal     : return ">="
                of lessgreater      : return "<>"

                of tilde            : return "~"
                of backtick         : return "`"
                of exclamation      : return "!"
                of at               : return "@"
                of sharp            : return "#"
                of dollar           : return "$"
                of percent          : return "%"
                of caret            : return "^"
                of ampersand        : return "&"
                of asterisk         : return "*"
                of minus            : return "-"
                of doubleminus      : return "--"
                of underscore       : return "_"
                of equal            : return "="
                of plus             : return "+"
                of doubleplus       : return "++"
                of lessthan         : return "<"
                of greaterthan      : return ">"
                of slash            : return "/"
                of doubleslash      : return "//"
                of backslash        : return "\\"
                of doublebackslash  : return "\\\\"
                of pipe             : return "|"
                of leftcurly        : return "{"
                of rightcurly       : return "}"

                of ellipsis         : return ".."
                of colon            : return ":"

        of Date     : return $(newDictionary(v.e))
        of Binary   : discard
        of Array,
           Inline,
           Block     :
            result = "["
            for i,child in v.a:
                result &= $(child) & " "

            result &= "]"

        of Dictionary   :
            result = "["
            let keys = toSeq(v.d.keys)

            if keys.len > 0:

                for key,value in v.d:
                    result &= key & ": "
                    result &= $(value)

            result &= "]"

        of Function     : 
            result = "["
            result &= $(v.params)
            result &= $(v.main)
            result &= "]"
            
        of ANY: discard


proc printOne(v: Value, level: int, isLast: bool, newLine: bool) =
    for i in 0..level-1: stdout.write "\t"

    case v.kind:
        of Null         : stdout.write "null"
        of Boolean      : stdout.write $(v.b)
        of Integer      : stdout.write $(v.i)
        of Floating     : stdout.write $(v.f)
        of Type         : stdout.write ":" & ($(v.t)).toLowerAscii()
        of Char         : stdout.write $(v.c)
        of String,
           Word,
           Literal,
           Label        : stdout.write v.s
        of Attr,
           AttrLabel    : stdout.write v.r
        of Path,
           PathLabel    : 
            for child in v.p:
                printOne(child, level, false, false)
                stdout.write "\\"
        of Symbol       : 
            case v.m:
                of thickarrowleft   : stdout.write "<="
                of thickarrowright  : stdout.write "=>"
                of arrowleft        : stdout.write "<-"
                of arrowright       : stdout.write "->"
                of doublearrowleft  : stdout.write "<<"
                of doublearrowright : stdout.write ">>"

                of equalless        : stdout.write "=<"
                of greaterequal     : stdout.write ">="
                of lessgreater      : stdout.write "<>"

                of tilde            : stdout.write "~"
                of backtick         : stdout.write "`"
                of exclamation      : stdout.write "!"
                of at               : stdout.write "@"
                of sharp            : stdout.write "#"
                of dollar           : stdout.write "$"
                of percent          : stdout.write "%"
                of caret            : stdout.write "^"
                of ampersand        : stdout.write "&"
                of asterisk         : stdout.write "*"
                of minus            : stdout.write "-"
                of doubleminus      : stdout.write "--"
                of underscore       : stdout.write "_"
                of equal            : stdout.write "="
                of plus             : stdout.write "+"
                of doubleplus       : stdout.write "++"
                of lessthan         : stdout.write "<"
                of greaterthan      : stdout.write ">"
                of slash            : stdout.write "/"
                of doubleslash      : stdout.write "//"
                of backslash        : stdout.write "\\"
                of doublebackslash  : stdout.write "\\\\"
                of pipe             : stdout.write "|"
                of leftcurly        : stdout.write "{"
                of rightcurly       : stdout.write "}"

                of ellipsis         : stdout.write ".."
                of colon            : stdout.write ":"

        of Date:
            printOne(newDictionary(v.e), level, false, newLine)

        of Binary: 
            for i, bt in v.n:
                stdout.write fmt"{bt:02X}"
                if i mod 2==1:
                    stdout.write " "

        of Array,
           Inline,
           Block     :
            stdout.write "["
            if newLine: stdout.write "\n"

            for i,child in v.a:
                printOne(child, level+1, i==(v.a.len-1), newLine)

            if newLine: stdout.write "\n"

            for i in 0..level-1: stdout.write "\t"
            stdout.write "]"

        of Dictionary   :
            stdout.write "["
            if newLine: stdout.write "\n"

            let keys = toSeq(v.d.keys)

            if keys.len > 0:
                let maxLen = (keys.map(proc (x: string):int = x.len)).max + 2

                for key,value in v.d:
                    for i in 0..level: stdout.write "\t"

                    if newLine: stdout.write alignLeft(key & ": ", maxLen)
                    else: stdout.write key & ": "

                    printOne(value, level+1, key == keys[keys.len-1], newLine)

                if newLine: stdout.write "\n"

            for i in 0..level-1: stdout.write "\t"
            stdout.write "]"

        of Function     : 
            stdout.write "["
            if newLine: stdout.write "\n"

            printOne(v.params, level+1, false, newLine)
            printOne(v.main, level+1, true, newLine)

            if newLine: stdout.write "\n"

            for i in 0..level-1: stdout.write "\t"
            stdout.write "]"
        of ANY: discard

    if (not isLast) and newLine:
        stdout.write "\n"

proc print*(v: Value, newLine: bool = true) = 
    printOne(v, 0, false, newLine)
    stdout.flushFile()

proc dump*(v: Value, level: int=0, isLast: bool=false) {.exportc.} = 

    proc dumpPrimitive(str: string, v: Value) {.inline.} =
        stdout.write fmt("{fgGreen}{str}{fgGray} :{($(v.kind)).toLowerAscii()}{fgWhite}")

    proc dumpIdentifier(v: Value) {.inline.} =
        stdout.write fmt("{fgWhite}{v.s}{fgGray} :{($(v.kind)).toLowerAscii()}{fgWhite}")

    proc dumpAttribute(v: Value) {.inline.} =
        stdout.write fmt("{fgWhite}{v.r}{fgGray} :{($(v.kind)).toLowerAscii()}{fgWhite}")

    proc dumpSymbol(v: Value) {.inline.} =
        stdout.write fmt("{fgWhite}<{v.m}>{fgGray} :{($(v.kind)).toLowerAscii()}{fgWhite}")

    proc dumpBlockStart(v: Value) {.inline.} =
        stdout.write fmt("{fgMagenta}[{fgGray} :{($(v.kind)).toLowerAscii()}{fgWhite}\n")

    proc dumpBlockEnd() =
        for i in 0..level-1: stdout.write "\t"
        stdout.write fmt("{fgMagenta}]{fgWhite}")

    for i in 0..level-1: stdout.write "\t"

    case v.kind:
        of Null         : dumpPrimitive("null",v)
        of Boolean      : dumpPrimitive($(v.b), v)
        of Integer      : dumpPrimitive($(v.i), v)
        of Floating     : dumpPrimitive($(v.f), v)
        of Type         : dumpPrimitive(($(v.t)).toLowerAscii(), v)
        of Char         : dumpPrimitive($(v.c), v)
        of String       : dumpPrimitive(v.s, v)
        
        of Word,
           Literal,
           Label        : dumpIdentifier(v)

        of Attr,
           AttrLabel    : dumpAttribute(v)

        of Path,
           PathLabel    :
            dumpBlockStart(v)

            for i,child in v.p:
                dump(child, level+1, i==(v.a.len-1))

            stdout.write "\n"

            dumpBlockEnd()

        of Symbol       : dumpSymbol(v)

        of Date         : dump(newDictionary(v.e))

        of Binary       : discard

        of Array,
           Inline,
           Block        :
            dumpBlockStart(v)

            for i,child in v.a:
                dump(child, level+1, i==(v.a.len-1))

            stdout.write "\n"

            dumpBlockEnd()

        of Dictionary   : 
            dumpBlockStart(v)

            let keys = toSeq(v.d.keys)

            if keys.len > 0:
                let maxLen = (keys.map(proc (x: string):int = x.len)).max + 2

                for key,value in v.d:
                    for i in 0..level: stdout.write "\t"

                    stdout.write alignLeft(key & " ", maxLen) & ":"

                    dump(value, level+1, false)

            dumpBlockEnd()
        of Function     : 
            dumpBlockStart(v)
            
            dump(v.params, level+1, false)
            dump(v.main, level+1, true)

            stdout.write "\n"

            dumpBlockEnd()
        of ANY          : discard

    if not isLast:
        stdout.write "\n"

proc hash*(v: Value): Hash {.inline.}=
    case v.kind:
        of Null         : result = 0
        of Boolean      : result = cast[Hash](v.b)
        of Integer      : result = cast[Hash](v.i)
        of Floating     : result = cast[Hash](v.f)
        of Type         : result = cast[Hash](ord(v.t))
        of Char         : result = cast[Hash](ord(v.c))
        of String       : result = hash(v.s)
        
        of Word,
           Literal,
           Label        : result = hash(v.s)

        of Attr,
           AttrLabel    : result = hash(v.r)

        of Path,
           PathLabel    : 
            result = 1
            for i in v.p:
                result = result !& hash(i)
            result = !$ result

        of Symbol       : result = cast[Hash](ord(v.m))

        of Date         : discard

        of Binary       : discard

        of Array,
           Inline,
           Block        : 
            result = 1
            for i in v.a:
                result = result !& hash(i)
            result = !$ result

        of Dictionary   : 
            result = 1
            for k,v in pairs(v.d):
                result = result !& hash(k)
                result = result !& hash(v)
        of Function     : 
            result = cast[Hash](unsafeAddr v)
            # result = hash(v.params) !& hash(v.main)
            # result = !$ result
        of ANY          : result = 0