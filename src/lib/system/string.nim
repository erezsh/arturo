#[*****************************************************************
  * Arturo
  * 
  * Programming Language + Interpreter
  * (c) 2019 Yanis Zafirópulos (aka Dr.Kameleon)
  *
  * @file: lib/system/string.nim
  *****************************************************************]#

#[######################################################
    Functions
  ======================================================]#

proc String_capitalize*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("capitalize", f.req)

    result = STR(S(0).capitalizeAscii())

proc String_capitalizeI*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("capitalize!", f.req)
    
    S(0) = S(0).capitalizeAscii()
    result = v[0]

proc String_isAlpha*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isAlpha", f.req)

    result = BOOL(S(0).isAlphaAscii())

proc String_isAlphaNumeric*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isAlphaNumeric", f.req)

    result = BOOL(S(0).isAlphaNumeric())

proc String_isLowercase*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isLowercase", f.req)

    result = BOOL(S(0).isLowerAscii(true))

proc String_isNumber*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isNumber", f.req)

    result = BOOL(S(0).isDigit())

proc String_isUppercase*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isUppercase", f.req)

    result = BOOL(S(0).isUpperAscii(true))

proc String_isWhitespace*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("isWhitespace", f.req)

    result = BOOL(S(0).isSpaceAscii())

proc String_lowercase*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("lowercase", f.req)

    result = STR(S(0).toLowerAscii())

proc String_lowercaseI*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("lowercase!", f.req)
    
    S(0) = S(0).toLowerAscii()
    result = v[0]

proc String_lines*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("lines", f.req)
    
    result = STRARR(S(0).splitLines())

proc String_uppercase*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("uppercase", f.req)

    result = STR(S(0).toUpperAscii())

proc String_uppercaseI*[F,X,V](f: F, xl: X): V {.inline.} =
    let v = xl.validate("uppercase!", f.req)
    
    S(0) = S(0).toUpperAscii()
    result = v[0]

#[******************************************************
  ******************************************************
    UnitTests
  ******************************************************
  ******************************************************]#

when defined(unittest):

    import unittest 

    suite "Library: system/string":

        test "capitalize":
            check(eq( callFunction("capitalize",@[STR("done")]), STR("Done") ))

        test "isAlpha":
            check(eq( callFunction("isAlpha",@[STR("done")]), TRUE ))
            check(eq( callFunction("isAlpha",@[STR("d3one")]), FALSE ))

        test "isAlphaNumeric":
            check(eq( callFunction("isAlphaNumeric",@[STR("done")]), TRUE ))
            check(eq( callFunction("isAlphaNumeric",@[STR("d3one")]), TRUE ))

        test "isLowercase":
            check(eq( callFunction("isLowercase",@[STR("done")]), TRUE ))
            check(eq( callFunction("isLowercase",@[STR("d3one")]), TRUE ))
            check(eq( callFunction("isLowercase",@[STR("d3oNe")]), FALSE ))

        test "isNumber":
            check(eq( callFunction("isNumber",@[STR("12345")]), TRUE ))
            check(eq( callFunction("isNumber",@[STR("d3one")]), FALSE ))
            check(eq( callFunction("isNumber",@[STR("done")]), FALSE ))

        test "isUppercase":
            check(eq( callFunction("isUppercase",@[STR("done")]), FALSE ))
            check(eq( callFunction("isUppercase",@[STR("dONe")]), FALSE ))
            check(eq( callFunction("isUppercase",@[STR("DONE")]), TRUE ))

        test "isWhitespace":
            check(eq( callFunction("isWhitespace",@[STR("done")]), FALSE ))
            check(eq( callFunction("isWhitespace",@[STR("  ")]), TRUE ))
            check(eq( callFunction("isWhitespace",@[STR("  \t\n")]), TRUE ))

        test "lowercase":
            check(eq( callFunction("lowercase",@[STR("dOnE")]), STR("done") ))

        test "lines":
            check(eq( callFunction("lines",@[STR("one\ntwo")]), STRARR(@["one","two"]) ))

        test "uppercase":
            check(eq( callFunction("uppercase",@[STR("dOnE")]), STR("DONE") ))
