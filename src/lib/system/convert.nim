#[*****************************************************************
  * Arturo
  * 
  * Programming Language + Interpreter
  * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
  *
  * @file: lib/system/convert.nim
  * @description: converting between different values
  *****************************************************************]#

#[######################################################
    Functions
  ======================================================]#

proc Convert_toBin*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,IV)

    result = STR(fmt"{I(v0):#b}")

proc Convert_toHex*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,IV)

    result = STR(fmt"{I(v0):#x}")

proc Convert_toNumber*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,SV|RV|BV)

    {.computedGoTo.}
    case v0.kind
        of SV:
            if unlikely(S(v0).startsWith("0x")): 
                var ret = 0
                discard parseHex(S(v0),ret)
                result = SINT(ret)
            elif unlikely(S(v0).startsWith("0b")):
                var ret = 0
                discard parseBin(S(v0),ret)
                result = SINT(ret)
            elif unlikely(S(v0).startsWith("0o")):
                var ret = 0
                discard parseOct(S(v0),ret)
                result = SINT(ret)
            else:
                if S(v0).contains("."):
                    var ret = 0.0
                    discard parseFloat(S(v0),ret)
                    result = REAL(ret)
                else:
                    try: 
                        var ret = 0
                        discard parseInt(S(v0),ret)
                        result = SINT(ret)
                    except Exception as e: 
                        result = BIGINT(S(v0))

        of RV: result = SINT(int(R(v0)))
        of BV: (if B(v0): result = SINT(1) else: result = SINT(0))
        else: discard

proc Convert_toOct*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,IV)

    result = STR(fmt"{I(v0):#o}")

proc Convert_toReal*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,IV)

    result = REAL(float(I(v0)))

proc Convert_toString*[F,X,V](f: F, xl: X): V {.inline.} =
    let v0 = VALID(0,ANY)

    result = STR(v0.stringify(quoted=false))

#[******************************************************
  ******************************************************
    UnitTests
  ******************************************************
  ******************************************************]#

when defined(unittest):

    suite "Library: system/convert":

        test "toBin":
            check(eq( callFunction("toBin",@[INT(15)]), STR("0b1111") ))

        test "toHex":
            check(eq( callFunction("toHex",@[INT(15)]), STR("0xf") ))

        test "toNumber":
            check(eq( callFunction("toNumber",@[STR("15")]), INT(15) ))
            check(eq( callFunction("toNumber",@[STR("15.0")]), REAL(15.0) ))
            check(eq( callFunction("toNumber",@[STR("0b1111")]), INT(15) ))
            check(eq( callFunction("toNumber",@[STR("0xf")]), INT(15) ))
            check(eq( callFunction("toNumber",@[STR("0o17")]), INT(15) ))

        test "toOct":
            check(eq( callFunction("toOct",@[INT(15)]), STR("0o17") ))

        test "toReal":
            check(eq( callFunction("toReal",@[INT(15)]), REAL(15.0) ))

        test "toString":
            check(eq( callFunction("toString",@[STR("done")]), STR("done") ))
            check(eq( callFunction("toString",@[INT(15)]), STR("15") ))
            check(eq( callFunction("toString",@[TRUE]), STR("true") ))
            check(eq( callFunction("toString",@[FALSE]), STR("false") ))
    