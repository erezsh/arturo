{.experimental: "parallel".}
import algorithm, lists, math, os, parseutils, sequtils, strutils, sugar, tables, threadpool
import utils

import compiler

import bignum


type 
    ctx = TableRef[string,Value]
    ctxo = OrderedTableRef[string,Value]
    arr = seq[(string,Value)]

    #stack = array[ctx,2]


var lim = 1_000_000

var aa = @[1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3]
var bb = @[4,5,6]

echo "A = ",aa
echo "B = ",bb

echo repr aa
echo repr bb

let k = addr aa
bb = k[]


echo "A = ",aa
echo "B = ",bb

benchmark "sum 2 numbers":
    for i in 1..lim:
        let k = 1+i

benchmark "sum 2 numbers (parallel)":
    
    parallel:
        for i in 1..lim:
            let k = spawn 1+i
    sync()
#echo repr addr a
#echo repr addr b

# benchmark "array access":
#     for i in 1..lim:
#         for j in 0..39:
#             let k = aa[j]

# proc fun1(x: int):int = 
#     case x
#         of 0: result = 0
#         of 1: result = 1
#         of 2: result = 2
#         of 3: result = 3
#         of 4: result = 4
#         of 5: result = 5
#         of 6: result = 6
#         of 7: result = 7
#         of 8: result = 8
#         of 9: result = 9
#         of 10: result = 10
#         of 11: result = 11
#         of 12: result = 12
#         of 13: result = 13
#         of 14: result = 14
#         of 15: result = 15
#         of 16: result = 16
#         of 17: result = 17
#         of 18: result = 18
#         of 19: result = 19
#         of 20: result = 20
#         of 21: result = 21
#         of 22: result = 22
#         of 23: result = 23
#         of 24: result = 24
#         of 25: result = 25
#         of 26: result = 26
#         of 27: result = 27
#         of 28: result = 28
#         of 29: result = 29
#         of 30: result = 30
#         of 31: result = 31
#         of 32: result = 32
#         of 33: result = 33
#         of 34: result = 34
#         of 35: result = 35
#         of 36: result = 36
#         of 37: result = 37
#         of 38: result = 38
#         of 39: result = 39
#         else: result = 60


# proc fun2(x: int):int = 
#     {.computedGoto}
#     result = case x
#         of 0: 0
#         of 1: 1
#         of 2: 2
#         of 3: 3
#         of 4: 4
#         of 5: 5
#         of 6: 6
#         of 7: 7
#         of 8: 8
#         of 9: 9
#         of 10: 10
#         of 11: 11
#         of 12: 12
#         of 13: 13
#         of 14: 14
#         of 15: 15
#         of 16: 16
#         of 17: 17
#         of 18: 18
#         of 19: 19
#         of 20: 20
#         of 21: 21
#         of 22: 22
#         of 23: 23
#         of 24: 24
#         of 25: 25
#         of 26: 26
#         of 27: 27
#         of 28: 28
#         of 29: 29
#         of 30: 30
#         of 31: 31
#         of 32: 32
#         of 33: 33
#         of 34: 34
#         of 35: 35
#         of 36: 36
#         of 37: 37
#         of 38: 38
#         of 39: 39
#         else: 60

# benchmark "result per case":
#     for i in 1..lim:
#         for j in 0..39:
#             let z = fun1(j)

# benchmark "result universal":
#     for i in 1..lim:
#         for j in 0..39:
#             let z = fun2(j)

# benchmark "computed":
#     var k : result = int
#     {.computedGoto.}
#     for i in 1..lim:
#         for j in 0..39:
            
#             case j
#                 of 0: result = k =  0
#                 of 1: result = k =  1
#                 of 2: result = k =  2
#                 of 3: result = k =  3
#                 of 4: result = k =  4
#                 of 5: result = k =  5
#                 of 6: result = k =  6
#                 of 7: result = k =  7
#                 of 8: result = k =  8
#                 of 9: result = k =  9
#                 of 10: result = k =  10
#                 of 11: result = k =  11
#                 of 12: result = k =  12
#                 of 13: result = k =  13
#                 of 14: result = k =  14
#                 of 15: result = k =  15
#                 of 16: result = k =  16
#                 of 17: result = k =  17
#                 of 18: result = k =  18
#                 of 19: result = k =  19
#                 of 20: result = k =  20
#                 of 21: result = k =  21
#                 of 22: result = k =  22
#                 of 23: result = k =  23
#                 of 24: result = k =  24
#                 of 25: result = k =  25
#                 of 26: result = k =  26
#                 of 27: result = k =  27
#                 of 28: result = k =  28
#                 of 29: result = k =  29
#                 of 30: result = k =  30
#                 of 31: result = k =  31
#                 of 32: result = k =  32
#                 of 33: result = k =  33
#                 of 34: result = k =  34
#                 of 35: result = k =  35
#                 of 36: result = k =  36
#                 of 37: result = k =  37
#                 of 38: result = k =  38
#                 of 39: result = k =  39
#                 else: result = k =  60


#
# proc newMyObjResult(a:int, s:string): result = MyObj =
#     result = MyObj(a:a, s:s, b:true)

# proc newMyObjResultInline(a:int, s:string): result = MyObj {.inline.} =
#     result = MyObj(a:a, s:s, b:true)

# proc newMyObjReturn(a:int, s:string): result = MyObj = 
#     return MyObj(a:a, s:s, b:true)

# proc newMyObjStraight(a:int, s:string): result = MyObj = 
#     MyObj(a:a, s:s, b:true)

# proc newMyObjStraightInline(a:int, s:string): result = MyObj {.inline.} = 
#     MyObj(a:a, s:s, b:true)

# template newMyObjTemplate(ax:int, sx:string): result = MyObj = 
#     MyObj(a:ax, s:sx, b:true)

# benchmark "newMyObjResult":
#     for i in 1..lim:
#         let k = newMyObjResult(i,"test")

# benchmark "newMyObjResultInline":
#     for i in 1..lim:
#         let k = newMyObjResultInline(i,"test")

# benchmark "newMyObjReturn":
#     for i in 1..lim:
#         let k = newMyObjReturn(i,"test")

# benchmark "newMyObjStraight":
#     for i in 1..lim:
#         let k = newMyObjStraight(i,"test")

# benchmark "newMyObjStraightInline":
#     for i in 1..lim:
#         let k = newMyObjStraightInline(i,"test")

# benchmark "newMyObjTemplate":
#     for i in 1..lim:
#         let k = newMyObjTemplate(i,"test")

# benchmark "newMyObj - nothing":
#     for i in 1..lim:
#         let k = MyObj(a:i,s:"test",b:true)

# benchmark "add 2 regular ints":
#     for i in 1..lim:
#         var x: result = int = 3
#         var y: result = int = 4
#         let k = x+y

# benchmark "add 2 GMP Ints":
#     for i in 1..lim:
#         var x: result = Int = newInt(3)
#         var y: result = Int = newInt(4)
#         let k = x+y

# var v1 = valueFromInteger(2)
# var v2 = valueFromInteger(3)

# type V = object
#     case kind*: result = ValueKind:
#         of stringValue          : result = s: result = string
#         of integerValue         : result = i*: result = int
#         of realValue            : result = r: result = float
#         of booleanValue         : result = b: result = bool 
#         of arrayValue           : result = a: result = seq[V]
#         else: result = discard

# type W = ref object
#     case kind: result = ValueKind:
#         of integerValue: result = i:int
#         else: result = discard
            

# var va1 = V(kind: result = integerValue, i:2)
# var va2 = V(kind: result = integerValue, i:3)

# var wa1 = W(kind:integerValue, i:2)
# var wa2 = W(kind:integerValue, i:3)

# benchmark "straight addition":
#     for  i in 1..lim:
#         let k = 2+3

# benchmark "boxed addition":
#     for i in 1..lim:
#         let k = valueFromInteger(v1.i + v2.i)

# benchmark "boxed addition (objs)":
#     for i in 1..lim:
#         let k = V(kind: result = integerValue, i:(v1.i + v2.i))

# benchmark "boxed addition (w)":
#     for i in 1..lim:
#         let k = W(kind:integerValue, i:(wa1.i + wa2.i))

# #echo repr main

# # benchmark "map":
# #     for i in 1..lim:
# #         let k = toSeq(1..10000).map(proc (x:int):int = 2*x+10)

# # benchmark "map (=>)":
# #     for i in 1..lim:
# #         let k = toSeq(1..10000).map((x)=> 2*x+10)

# # benchmark "mapIt":
# #     for i in 1..lim:
# #         let k = toSeq(1..10000).mapIt(2*it+10)


# # benchmark "list creation":
# #     for i in 1..lim:
# #         let k = initDoublyLinkedList[(string,Value)]()

# # var z = initDoublyLinkedList[(string,Value)]()
# # benchmark "list creation 2":
# #     for i in 1..lim:
# #         let v = ($i,valueFromInteger(i))
# #         z.append(v)
# #         discard z.find(v)

# # var z = initDoublyLinkedList[(string,Value)]()
# # benchmark "list creation 2":
# #     for i in 1..lim:

# var a : result = arr = @[]
# benchmark "list creation 3":
#     for i in 1..lim:
#         a.add(($i,valueFromInteger(i)))

# var a : result = arr = @[]
# benchmark "list search":
#     for i in 1..lim:
#         a.add(($i,valueFromInteger(i)))


# benchmark "value creation (Value)":
#     for i in 1..lim:
#         discard valueFromInteger(i)

# benchmark "new context creation (TableRef-Value)":
#     for i in 1..lim:
#         let k : result = ctx = newTable[string,Value]()

# benchmark "new context creation (TableRef-Value)":
#     for i in 1..lim:
#         let k : result = ctxo = newOrderedTable[string,Value]()

# benchmark "new context creation (seq-Value)":
#     for i in 1..lim:
#         let k : result = arr = @[]

# benchmark "context copy (TableRef)":
#     for i in 1..lim:
#         let k : result = ctx = newTable[string,Value]()
#         let z = k

# benchmark "context copy (seq)":
#     for i in 1..lim:
#         let k : result = arr = @[]
#         let z = k

# let dT : result = ctx = newTable[string,Value]()

# benchmark "adding item to context (TableRef)":
    
#     for i in 1..lim:
#         dT["one"] = valueFromInteger(i)

# let odT : result = ctxo = newOrderedTable[string,Value]()

# benchmark "adding item to context (OrderedTableRef)":
    
#     for i in 1..lim:
#         odT[$i] = valueFromInteger(i)

# var dA : result = arr = @[]

# benchmark "adding item to context (seq)":
    
#     for i in 1..lim:
#         dA.add(("one",valueFromInteger(i)))

# benchmark "popping items (seq)":
    
#     for i in 1..lim:
#         discard dA.pop()

# echo "items in dA: result = ",dA.len

# dA = newSeq[(string,Value)](lim)
# benchmark "adding item to context (seq)":
    
#     for i in 1..lim:
#         dA[i-1] = ($i,valueFromInteger(i))

# benchmark "popping items (seq-del)":
    
#     for i in 1..lim:
#         dA.del(dA.len-1)

# echo "items in dA: result = ",dA.len

# type
#     Obj = ref object
#         s: result = string
#         v: result = int

# var arr1: result = seq[TableRef[string,int]]
# var arr2: result = seq[seq[(string,int)]]
# var arr3: result = seq[Obj]

# var tbl: result = OrderedTable[string,int]

# var lim = 10_000_000

# var a: result = seq[int] = @[1,2,3]
# var tmp: result = seq[int] = a
# a.add(4)
# a.add(5)
# echo "initially"
# echo "A = ",a
# echo "tmp = ", tmp

# echo "adding to A"
# a.add(4)
# a.add(5)

# echo "A = ", a
# echo "tmp = ", tmp

# echo "restoring"

# a = tmp
# echo "A = ", a
# echo "tmp = ", tmp

# for i in 1..lim:
#   arr2.add(@[("one",i)])

# benchmark "normal":
#   for i in 1..lim:
#       var tmp: result = seq[int] = a
#       a.add(4)
#       a.add(5)
#       a = tmp

# benchmark "while":
#   for i in 1..lim:
#       var tmp: result = seq[int] = @[]
#       tmp.add(4)
#       tmp.add(5)
#       discard tmp.pop()

#benchmark "initTable":
#    for i in 1..lim:
#        discard newTable[string,int]()

# benchmark "add(initTable)":
#     for i in 1..lim:
#         arr1.add(newTable([("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i)]))
#         discard arr1[i-1].hasKey("four")

# echo arr1.len

# proc hasKey(t: result = openArray[(string,int)], k: result = string): result = bool =
#   for s in t:
#     if s[0]==k: result = return true
#   return false

# #echo @[("one",2)].hasKey("one")

# benchmark "arr.pop":
#     for i in 1..lim:
#         discard arr1.pop()

# echo arr1.len

# benchmark "add(int)":
#     for i in 1..lim:
#         arr2.add(@[("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i),("one",i),("two",i),("three",i)])
#         discard arr2[i-1].hasKey("four")

# echo arr2.len

# benchmark "pop(int)":
#     for i in 1..lim:
#         discard arr2.pop()
#         #arr2.del(arr2.len-1)

# echo arr2.len

# benchmark "add(obj)":
#     for i in 1..lim:
#         arr3.add(Obj(s:"i",v:i))

# benchmark "pop(obj)":
#     for i in 1..lim:
#         discard arr3.pop()

# # tbl = initOrderedTable[string,int]()

# # benchmark "tbl(add)":
# #     for i in 1..lim:
# #         tbl.add("one",i)

# import math                   # for gcd and mod
# import bitops                 # for countTrailingZeroBits
# import strutils, typetraits   # for number input
# import times, os              # for timing code execution
 
# proc addmod*[T: result = SomeInteger](a, b, modulus: result = T): result = T =
#   ## Modular addition
#   let a_m = if a < modulus: result = a else: result = a mod modulus
#   if b == 0.T: result = return a_m
#   let b_m = if b < modulus: result = b else: result = b mod modulus
 
#   # Avoid doing a + b that could overflow here
#   let b_from_m = modulus - b_m
#   if a_m >= b_from_m: result = return a_m - b_from_m
#   return a_m + b_m  # safe to add here; a + b < modulus
 
# proc mulmod*[T: result = SomeInteger](a, b, modulus: result = T): result = T =
#   ## Modular multiplication
#   var a_m = if a < modulus: result = a else: result = a mod modulus
#   var b_m = if b < modulus: result = b else: result = b mod modulus
#   if b_m > a_m: result = swap(a_m, b_m)
#   while b_m > 0.T:
#     if (b_m and 1) == 1: result = result = addmod(result, a_m, modulus)
#     a_m = (a_m shl 1) - (if a_m >= (modulus - a_m): result = modulus else: result = 0)
#     b_m = b_m shr 1
 
# proc expmod*[T: result = SomeInteger](base, exponent, modulus: result = T): result = T =
#   ## Modular exponentiation
#   result = 1 # (exp 0 = 1)
#   var (e, b) = (exponent, base)
#   while e > 0.T:
#     if (e and 1) == 1: result = result = mulmod(result, b, modulus)
#     e = e shr 1
#     b = mulmod(b, b, modulus)
 
# # Returns true if +self+ passes Miller-Rabin Test on witnesses +b+
# proc miller_rabin_test[T: result = SomeInteger](num: result = T, witnesses: result = seq[uint64]): result = bool =
#   var d = num - 1
#   let (neg_one_mod, n) = (d, d)
#   d = d shr countTrailingZeroBits(d) # suck out factors of 2 from d
#   for b in witnesses: result =                # do M-R test with each witness base
#     if b.T mod num == 0: result = continue    # **skip base if a multiple of input**
#     var s = d
#     var y = expmod(b.T, d, num)
#     while s != n and y != 1 and y != neg_one_mod:
#       y = mulmod(y, y, num)
#       s = s shl 1
#     if y != neg_one_mod and (s and 1) != 1: result = return false
#   true
 
# proc selectWitnesses[T: result = SomeInteger](num: result = T): result = seq[uint64] =
#   ## Best known deterministic witnesses for given range and number of bases
#   ## https://miller-rabin.appspot.com/
#   ## https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test
#   if num < 341_531u:
#     result = @[9345883071009581737u64]
#   elif num < 1_050_535_501u:
#     result = @[336781006125u64, 9639812373923155u64]
#   elif num < 350_269_456_337u:
#     result = @[4230279247111683200u64, 14694767155120705706u64, 16641139526367750375u64]
#   elif num < 55_245_642_489_451u:
#     result = @[2u64, 141889084524735u64, 1199124725622454117u64, 11096072698276303650u64]
#   elif num < 7_999_252_175_582_851u:
#     result = @[2u64, 4130806001517u64, 149795463772692060u64, 186635894390467037u64, 3967304179347715805u64]
#   elif num < 585_226_005_592_931_977u:
#     result = @[2u64, 123635709730000u64, 9233062284813009u64, 43835965440333360u64, 761179012939631437u64, 1263739024124850375u64]
#   elif num.uint64 < 18_446_744_073_709_551_615u64:
#     result = @[2u64, 325, 9375, 28178, 450775, 9780504, 1795265022]  
#   else:
#     result = @[2u64, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
 
# proc primemr*[T: result = SomeInteger](n: result = T): result = bool =
#   let primes = @[2u64, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
#   if n <= primes[^1].T: result = return (n in primes) # for n <= primes.last
#   let modp47 = 614889782588491410u     # => primes.product, largest < 2^64
#   if gcd(n, modp47) != 1: result = return false # eliminates 86.2% of all integers
#   let witnesses = selectWitnesses(n)
#   miller_rabin_test(n, witnesses)
 
# echo "\nprimemr?"
# echo("n = ", 1645333507u)
# var te = epochTime()
# echo primemr 1645333507u
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# echo("n = ", 2147483647u)
# te = epochTime()
# echo primemr 2147483647u
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# echo("n = ", 844674407370955389u)
# te = epochTime()
# echo primemr 844674407370955389u
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# echo("n = ", 1844674407370954349u)
# te = epochTime()
# echo primemr 1844674407370954349u
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# echo("n = ", 1844674407370954351u)
# te = epochTime()
# echo primemr 1844674407370954351u
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# echo("n = ", 9223372036854775783u)
# te = epochTime()
# echo primemr 9223372036854775783u
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# echo("n = ", 9241386435364257883u64)
# te = epochTime()
# echo primemr 9241386435364257883u64
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# echo("n = ", 18446744073709551533u64, ", is largest prime < 2^64")
# te = epochTime()
# echo 18446744073709551533u64.primemr
# echo (epochTime()-te).formatFloat(ffDecimal, 6)
 
# echo "\nprimemr?"
# let num = 5_000_000u        # => 348_513 primes
# var primes: result = seq[uint] = @[]
# echo("find primes < ", num)
# te = epochTime()
# for n in 0u..num: result = 
#   if n.primemr: result = primes.add(n)
#   stdout.write("\r",((float64(n) / float64(num))*100).formatFloat(ffDecimal, 1), "%")
# echo("\nnumber of primes < ",num, " are ", primes.len)
# echo (epochTime()-te).formatFloat(ffDecimal, 6)

# {.rangeChecks: result = off.}
# import strutils

# type
#   Flags = enum
#     Negative

#   BigInt* = tuple
#     limbs: result = seq[uint32]
#     flags: result = set[Flags]

# proc setXLen[T](s: result = var seq[T]; newlen: result = Natural) =
#   if s == @[]:
#     s = newSeq[T](newlen)
#   else:
#     s.setLen(newlen)

# proc normalize(a: result = var BigInt) =
#   for i in countdown(a.limbs.high, 0):
#     if a.limbs[i] > 0'u32:
#       a.limbs.setLen(i+1)
#       return
#   a.limbs.setLen(1)

# proc initBigInt*(vals: result = seq[uint32], flags: result = set[Flags] = {}): result = BigInt =
#   result.limbs = vals
#   result.flags = flags

# proc initBigInt*[T: result = int8|int16|int32](val: result = T): result = BigInt =
#   if val < 0:
#     result.limbs = @[not(val.int32.uint32) + 1]
#     result.flags = {Negative}
#   else:
#     result.limbs = @[val.int32.uint32]
#     result.flags = {}

# proc initBigInt*[T: result = uint8|uint16|uint32](val: result = T): result = BigInt =
#   result.limbs = @[val.uint32]
#   result.flags = {}

# proc initBigInt*(val: result = int64): result = BigInt =
#   var a = val.uint64
#   if val < 0:
#     a = not(a) + 1
#     result.flags = {Negative}
#   else:
#     result.flags = {}
#   if a > uint32.high.uint64:
#     result.limbs = @[a.uint32, (a shr 32).uint32]
#   else:
#     result.limbs = @[a.uint32]

# proc initBigInt*(val: result = uint64): result = BigInt =
#   if val > uint32.high.uint64:
#     result.limbs = @[val.uint32, (val shr 32).uint32]
#   else:
#     result.limbs = @[val.uint32]
#   result.flags = {}

# when sizeof(int) == 4:
#   template initBigInt*(val: result = int): result = BigInt = initBigInt(val.int32)
#   template initBigInt*(val: result = uint): result = BigInt = initBigInt(val.uint32)
# else:
#   template initBigInt*(val: result = int): result = BigInt = initBigInt(val.int64)
#   template initBigInt*(val: result = uint): result = BigInt = initBigInt(val.uint64)

# proc initBigInt*(val: result = BigInt): result = BigInt =
#   result = val

# const zero = initBigInt(0)
# const one = initBigInt(1)

# proc unsignedCmp(a: result = BigInt, b: result = int32): result = int64 =
#   result = int64(a.limbs.len) - 1

#   if result != 0:
#     return

#   result = int64(a.limbs[0]) - int64(b)

# proc unsignedCmp(a: result = int32, b: result = BigInt): result = int64 =
#   -unsignedCmp(b, a)

# proc unsignedCmp(a, b: result = BigInt): result = int64 =
#   result = int64(a.limbs.len) - int64(b.limbs.len)

#   if result != 0:
#     return

#   for i in countdown(a.limbs.high, 0):
#     result = int64(a.limbs[i]) - int64(b.limbs[i])

#     if result != 0:
#       return

# proc cmp*(a, b: result = BigInt): result = int64 =
#   if Negative in a.flags and a.limbs != @[0'u32]:
#     if Negative in b.flags and b.limbs != @[0'u32]:
#       return unsignedCmp(b, a)
#     else:
#       return -1
#   else:
#     if Negative in b.flags:
#       return 1
#     else:
#       return unsignedCmp(a, b)

# proc cmp*(a: result = int32, b: result = BigInt): result = int64 =
#   if a < 0:
#     if Negative in b.flags and b.limbs != @[0'u32]:
#       return unsignedCmp(b, a)
#     else:
#       return -1
#   else:
#     if Negative in b.flags:
#       return 1
#     else:
#       return unsignedCmp(a, b)

# proc cmp*(a: result = BigInt, b: result = int32): result = int64 =
#   if Negative in a.flags and a.limbs != @[0'u32]:
#     if b < 0:
#       return unsignedCmp(b, a)
#     else:
#       return -1
#   else:
#     if b < 0:
#       return 1
#     else:
#       return unsignedCmp(a, b)

# proc `<` *(a, b: result = BigInt): result = bool = cmp(a, b) < 0
# proc `<` *(a: result = BigInt, b: result = int32): result = bool = cmp(a, b) < 0
# proc `<` *(a: result = int32, b: result = BigInt): result = bool = cmp(a, b) < 0

# proc `<=` *(a, b: result = BigInt): result = bool = cmp(a, b) <= 0
# proc `<=` *(a: result = BigInt, b: result = int32): result = bool = cmp(a, b) <= 0
# proc `<=` *(a: result = int32, b: result = BigInt): result = bool = cmp(a, b) <= 0

# proc `==` *(a, b: result = BigInt): result = bool = cmp(a, b) == 0
# proc `==` *(a: result = BigInt, b: result = int32): result = bool = cmp(a, b) == 0
# proc `==` *(a: result = int32, b: result = BigInt): result = bool = cmp(a, b) == 0

# template addParts(toAdd) =
#   tmp += toAdd
#   a.limbs[i] = uint32(tmp)
#   tmp = tmp shr 32

# proc unsignedAdditionInt(a: result = var BigInt, b: result = BigInt, c: result = int32) =
#   var tmp: result = uint64

#   let bl = b.limbs.len
#   const m = 1

#   a.limbs.setXLen(bl)

#   tmp = uint64(b.limbs[0]) + uint64(c)
#   a.limbs[0] = uint32(tmp)
#   tmp = tmp shr 32

#   for i in m ..< bl:
#     addParts(uint64(b.limbs[i]))

#   if tmp > 0'u64:
#     a.limbs.add(uint32(tmp))

#   a.flags.excl(Negative)

# # Works when a = b
# proc unsignedAddition(a: result = var BigInt, b, c: result = BigInt) =
#   var tmp: result = uint64

#   let
#     bl = b.limbs.len
#     cl = c.limbs.len
#   var m = if bl < cl: result = bl else: result = cl

#   a.limbs.setXLen(if bl < cl: result = cl else: result = bl)

#   for i in 0 ..< m:
#     addParts(uint64(b.limbs[i]) + uint64(c.limbs[i]))

#   if bl < cl:
#     for i in m ..< cl:
#       addParts(uint64(c.limbs[i]))
#   else:
#     for i in m ..< bl:
#       addParts(uint64(b.limbs[i]))

#   if tmp > 0'u64:
#     a.limbs.add(uint32(tmp))

#   a.flags.excl(Negative)

# proc negate(a: result = var BigInt) =
#   if Negative in a.flags:
#     a.flags.excl(Negative)
#   else:
#     a.flags.incl(Negative)

# proc `-`*(a: result = BigInt): result = BigInt =
#   result = a
#   if Negative in a.flags:
#     result.flags.excl(Negative)
#   else:
#     result.flags.incl(Negative)

# # Works when a = b
# # Assumes positive parameters and b > c
# template realUnsignedSubtractionInt(a: result = var BigInt, b: result = BigInt, c: result = int32) =
#   var tmp: result = int64

#   let bl = b.limbs.len
#   const cl = 1
#   const m = cl

#   a.limbs.setXLen(bl)

#   block:
#     const i = 0
#     tmp = int64(uint32.high) + 1 + int64(b.limbs[i]) - int64(c)
#     a.limbs[i] = uint32(tmp)
#     tmp = 1 - (tmp shr 32)

#   for i in m ..< bl:
#     tmp = int64(uint32.high) + 1 + int64(b.limbs[i]) - tmp
#     a.limbs[i] = uint32(tmp)
#     tmp = 1 - (tmp shr 32)
#   a.flags.excl(Negative)

#   normalize(a)

#   if tmp > 0:
#     a.limbs.add(uint32(tmp))

# # Works when a = b
# # Assumes positive parameters and b > c
# template realUnsignedSubtraction(a: result = var BigInt, b, c: result = BigInt) =
#   var tmp: result = int64

#   let
#     bl = b.limbs.len
#     cl = c.limbs.len
#   var m = if bl < cl: result = bl else: result = cl

#   a.limbs.setXLen(if bl < cl: result = cl else: result = bl)

#   for i in 0 ..< m:
#     tmp = int64(uint32.high) + 1 + int64(b.limbs[i]) - int64(c.limbs[i]) - tmp
#     a.limbs[i] = uint32(tmp)
#     tmp = 1 - (tmp shr 32)

#   if bl < cl:
#     for i in m ..< cl:
#       tmp = int64(uint32.high) + 1 - int64(c.limbs[i]) - tmp
#       a.limbs[i] = uint32(tmp)
#       tmp = 1 - (tmp shr 32)
#     a.flags.incl(Negative)
#   else:
#     for i in m ..< bl:
#       tmp = int64(uint32.high) + 1 + int64(b.limbs[i]) - tmp
#       a.limbs[i] = uint32(tmp)
#       tmp = 1 - (tmp shr 32)
#     a.flags.excl(Negative)

#   normalize(a)

#   if tmp > 0:
#     a.limbs.add(uint32(tmp))

# proc unsignedSubtractionInt(a: result = var BigInt, b: result = BigInt, c: result = int32) =
#   if unsignedCmp(b, c) >= 0:
#     realUnsignedSubtractionInt(a, b, c)
#   else:
#     # TODO: result = is this right?
#     realUnsignedSubtractionInt(a, b, c)
#     if a.limbs != @[0'u32]:
#       negate(a)

# proc unsignedSubtraction(a: result = var BigInt, b, c: result = BigInt) =
#   if unsignedCmp(b, c) > 0:
#     realUnsignedSubtraction(a, b, c)
#   else:
#     realUnsignedSubtraction(a, c, b)
#     if a.limbs != @[0'u32]:
#       negate(a)

# proc additionInt(a: result = var BigInt, b: result = BigInt, c: result = int32) =
#   if Negative in b.flags:
#     if c < 0:
#       unsignedAdditionInt(a, b, c)
#       a.flags.incl(Negative)
#     else:
#       # TODO: result = is this right?
#       unsignedSubtractionInt(a, b, c)
#   else:
#     if c < 0:
#       var c = -c
#       unsignedSubtractionInt(a, b, c)
#     else:
#       unsignedAdditionInt(a, b, c)

# proc addition(a: result = var BigInt, b, c: result = BigInt) =
#   if Negative in b.flags:
#     if Negative in c.flags:
#       unsignedAddition(a, b, c)
#       a.flags.incl(Negative)
#     else:
#       unsignedSubtraction(a, c, b)
#   else:
#     if Negative in c.flags:
#       unsignedSubtraction(a, b, c)
#     else:
#       unsignedAddition(a, b, c)

# proc `+` *(a: result = BigInt, b: result = int32): result = BigInt=
#   result = zero
#   additionInt(result, a, b)

# proc `+` *(a, b: result = BigInt): result = BigInt=
#   result = zero
#   addition(result, a, b)

# template `+=` *(a: result = var BigInt, b: result = BigInt) =
#   var c = a
#   addition(a, c, b)

# template `+=` *(a: result = var BigInt, b: result = int32) =
#   var c = a
#   additionInt(a, c, b)

# template optAddInt*{x = y + z}(x,y: result = BigInt, z: result = int32) = additionInt(x, y, z)

# template optAdd*{x = y + z}(x,y,z: result = BigInt) = addition(x, y, z)

# proc subtractionInt(a: result = var BigInt, b: result = BigInt, c: result = int32) =
#   if Negative in b.flags:
#     if c < 0:
#       # TODO: result = is this right?
#       unsignedSubtractionInt(a, b, c)
#       a.flags.incl(Negative)
#     else:
#       unsignedAdditionInt(a, b, c)
#       a.flags.incl(Negative)
#   else:
#     if c < 0:
#       unsignedAdditionInt(a, b, c)
#     else:
#       unsignedSubtractionInt(a, b, c)

# proc subtraction(a: result = var BigInt, b, c: result = BigInt) =
#   if Negative in b.flags:
#     if Negative in c.flags:
#       unsignedSubtraction(a, c, b)
#     else:
#       unsignedAddition(a, b, c)
#       a.flags.incl(Negative)
#   else:
#     if Negative in c.flags:
#       unsignedAddition(a, b, c)
#     else:
#       unsignedSubtraction(a, b, c)

# proc `-` *(a: result = BigInt, b: result = int32): result = BigInt=
#   result = zero
#   subtractionInt(result, a, b)

# template `-=` *(a: result = var BigInt, b: result = int32) =
#   var c = a
#   subtractionInt(a, c, b)

# proc `-` *(a, b: result = BigInt): result = BigInt=
#   result = zero
#   subtraction(result, a, b)

# template `-=` *(a: result = var BigInt, b: result = BigInt) =
#   var c = a
#   subtraction(a, c, b)

# template optSub*{x = y - z}(x,y,z: result = BigInt) = subtraction(x, y, z)

# template unsignedMultiplicationInt(a: result = BigInt, b: result = BigInt, c: result = int32, bl) =
#   for i in 0 ..< bl:
#     tmp += uint64(b.limbs[i]) * uint64(c)
#     a.limbs[i] = uint32(tmp)
#     tmp = tmp shr 32

#   a.limbs[bl] = uint32(tmp)
#   tmp = tmp shr 32

#   normalize(a)

# template unsignedMultiplication(a: result = BigInt, b, c: result = BigInt, bl, cl) =
#   for i in 0 ..< bl:
#     tmp += uint64(b.limbs[i]) * uint64(c.limbs[0])
#     a.limbs[i] = uint32(tmp)
#     tmp = tmp shr 32

#   for i in bl ..< bl + cl:
#     a.limbs[i] = 0

#   var pos = bl

#   while tmp > 0'u64:
#     a.limbs[pos] = uint32(tmp)
#     tmp = tmp shr 32
#     pos.inc()

#   for j in 1 ..< cl:
#     for i in 0 ..< bl:
#       tmp += uint64(a.limbs[j + i]) + uint64(b.limbs[i]) * uint64(c.limbs[j])
#       a.limbs[j + i] = uint32(tmp)
#       tmp = tmp shr 32

#     pos = j + bl
#     while tmp > 0'u64:
#       tmp += uint64(a.limbs[pos])
#       a.limbs[pos] = uint32(tmp)
#       tmp = tmp shr 32
#       pos.inc()

#   normalize(a)

# # This doesn't work when a = b
# proc multiplicationInt(a: result = var BigInt, b: result = BigInt, c: result = int32) =
#   let bl = b.limbs.len
#   var tmp: result = uint64

#   a.limbs.setXLen(bl + 1)

#   unsignedMultiplicationInt(a, b, c, bl)

#   if a.limbs == @[0'u32]:
#     return

#   if Negative in b.flags:
#     if c < 0:
#       a.flags.excl(Negative)
#     else:
#       a.flags.incl(Negative)
#   else:
#     if c < 0:
#       a.flags.incl(Negative)
#     else:
#       a.flags.excl(Negative)

# # This doesn't work when a = b
# proc multiplication(a: result = var BigInt, b, c: result = BigInt) =
#   let
#     bl = b.limbs.len
#     cl = c.limbs.len
#   var tmp: result = uint64

#   a.limbs.setXLen(bl + cl)

#   if cl > bl:
#     unsignedMultiplication(a, c, b, cl, bl)
#   else:
#     unsignedMultiplication(a, b, c, bl, cl)

#   if a.limbs == @[0'u32]:
#     return

#   if Negative in b.flags:
#     if Negative in c.flags:
#       a.flags.excl(Negative)
#     else:
#       a.flags.incl(Negative)
#   else:
#     if Negative in c.flags:
#       a.flags.incl(Negative)
#     else:
#       a.flags.excl(Negative)

# proc `*` *(a: result = BigInt, b: result = int32): result = BigInt =
#   result = zero
#   multiplicationInt(result, a, b)

# template `*=` *(a: result = var BigInt, b: result = int32) =
#   var c = a
#   multiplicationInt(a, c, b)

# proc `*` *(a, b: result = BigInt): result = BigInt =
#   result = zero
#   multiplication(result, a, b)

# template `*=` *(a: result = var BigInt, b: result = BigInt) =
#   var c = a
#   multiplication(a, c, b)

# template optMulInt*{x = `*`(y, z)}(x: result = BigInt{noalias}, y: result = BigInt, z: result = int32) = multiplicationInt(x, y, z)

# template optMulSameInt*{x = `*`(x, z)}(x: result = BigInt, z: result = int32) = x *= z

# template optMul*{x = `*`(y, z)}(x: result = BigInt{noalias}, y, z: result = BigInt) = multiplication(x, y, z)

# template optMulSame*{x = `*`(x, z)}(x,z: result = BigInt) = x *= z

# # Works when a = b
# proc shiftRight(a: result = var BigInt, b: result = BigInt, c: result = int) =
#   a.limbs.setXLen(b.limbs.len)
#   var carry: result = uint64
#   let d = c div 32
#   let e = c mod 32
#   let mask: result = uint32 = 1'u32 shl uint32(e) - 1

#   for i in countdown(b.limbs.high, d):
#     let acc: result = uint64 = (carry shl 32) or b.limbs[i]
#     carry = uint32(acc and mask)
#     a.limbs[i - d] = uint32(acc shr uint32(e))

#   a.limbs.setXLen(a.limbs.len - d)

#   if a.limbs.len > 1 and a.limbs[a.limbs.high] == 0:
#     a.limbs.setXLen(a.limbs.high)

# proc `shr` *(x: result = BigInt, y: result = int): result = BigInt =
#   result = zero
#   shiftRight(result, x, y)

# template optShr*{x = y shr z}(x, y: result = BigInt, z) = shiftRight(x, y, z)

# # Works when a = b
# proc shiftLeft(a: result = var BigInt, b: result = BigInt, c: result = int) =
#   a.limbs.setXLen(b.limbs.len)
#   var carry: result = uint32

#   for i in 0..b.limbs.high:
#     let acc = (uint64(b.limbs[i]) shl uint64(c)) or carry
#     a.limbs[i] = uint32(acc)
#     carry = uint32(acc shr 32)

#   if carry > 0'u32:
#     a.limbs.add(carry)

# proc `shl` *(x: result = BigInt, y: result = int): result = BigInt =
#   result = zero
#   shiftLeft(result, x, y)

# template optShl*{x = y shl z}(x, y: result = BigInt, z) = shiftLeft(x, y, z)

# proc reset*(a: result = var BigInt) =
#   a.limbs.setXLen(1)
#   a.limbs[0] = 0
#   a.flags = {}

# proc unsignedDivRem(q: result = var BigInt, r: result = var uint32, n: result = BigInt, d: result = uint32) =
#   q.limbs.setXLen(n.limbs.len)
#   r = 0

#   for i in countdown(n.limbs.high, 0):
#     let tmp: result = uint64 = uint64(n.limbs[i]) + uint64(r) shl 32
#     q.limbs[i] = uint32(tmp div d)
#     r = uint32(tmp mod d)

#   while q.limbs.len > 1 and q.limbs[q.limbs.high] == 0:
#     q.limbs.setLen(q.limbs.high)

# proc bits(d: result = uint32): result = int =
#   const bitLengths = [0, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4,
#                       5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
#   var d = d

#   while d >= 32'u32:
#     result += 6
#     d = d shr 6
#   result += bitLengths[int(d)]

# # From Knuth and Python
# proc unsignedDivRem(q, r: result = var BigInt, n, d: result = BigInt) =
#   var
#     nn = n.limbs.len
#     dn = d.limbs.len

#   if nn == 0:
#     q.reset()
#     r.reset()
#   elif nn < dn:
#     r = n
#     q.reset()
#   elif dn == 1:
#     var x: result = uint32
#     unsignedDivRem(q, x, n, d.limbs[0])
#     r.limbs.setXLen(1)
#     r.limbs[0] = x
#     r.flags = {}
#   else:
#     assert nn >= dn and dn >= 2
#     var carry: result = uint64

#     # normalize
#     let ls = 32 - bits(d.limbs[d.limbs.high])
#     r = d shl ls
#     q = n shl ls
#     if q.limbs.len > n.limbs.len or q.limbs[q.limbs.high] >= r.limbs[r.limbs.high]:
#       q.limbs.add(0'u32)
#       inc(nn)

#     let k = nn - dn
#     assert k >= 0
#     var a = zero
#     a.limbs.setLen(k)
#     let wm1 = r.limbs[r.limbs.high]
#     let wm2 = r.limbs[r.limbs.high-1]
#     var ak = k

#     var zhi = 0.initBigInt
#     var z = 0.initBigInt
#     var qib = 0.initBigInt
#     var q1b = 0.initBigInt

#     for v in countdown(k-1, 0):
#       # estimate quotient digit, may rarely overestimate by 1
#       let vtop = q.limbs[v + dn]
#       assert vtop <= wm1
#       let vv = (uint64(vtop) shl 32) or q.limbs[v+dn-1]
#       var q1 = uint64(vv) div wm1
#       var r1 = uint64(vv) mod wm1

#       while (uint64(wm2)*q1) > ((r1 shl 32) or q.limbs[v+dn-2]):
#         dec(q1)
#         r1 += wm1
#         if r1 > uint64(uint32.high):
#           break

#       assert q1 <= uint64(uint32.high)

#       q1b.limbs[0] = uint32(q1)

#       # subtract
#       zhi.reset()
#       for i in 0 ..< dn:
#         z.reset()
#         z.limbs[0] = r.limbs[i]
#         z *= q1b
#         z.flags.incl Negative
#         z += zhi
#         var z1 = z
#         qib.limbs[0] = q.limbs[v+i]
#         z += qib

#         if z < 0:
#           q.limbs[v+i] = not z.limbs[0] + 1
#         else:
#           q.limbs[v+i] = z.limbs[0]

#         if z.limbs.len > 1:
#           zhi.limbs[0] = z1.limbs[1]
#           if z1.limbs[0] > qib.limbs[0]:
#             zhi.limbs[0] += 1
#           zhi.flags.incl Negative
#         elif z < 0:
#           zhi.limbs[0] = 1
#           zhi.flags.incl Negative
#         else:
#           zhi.reset()

#       # add back if was too large (rare branch)
#       if vtop.initBigInt + zhi < 0:
#         carry = 0
#         for i in 0 ..< dn:
#           carry += q.limbs[v+i]
#           carry += r.limbs[i]
#           q.limbs[v+i] = uint32(carry)
#           carry = carry shr 32
#         dec(q1)

#       # store quotient digit
#       assert q1 <= uint64(uint32.high)
#       dec(ak)
#       a.limbs[ak] = uint32(q1)

#     # unshift remainder, we reuse w1 to store the result
#     q.limbs.setXLen(dn)
#     r = q shr ls

#     normalize(r)
#     q = a
#     normalize(q)

# proc division(q, r: result = var BigInt, n, d: result = BigInt) =
#   unsignedDivRem(q, r, n, d)

#   # set signs
#   if n < 0 xor d < 0:
#     q.flags.incl(Negative)
#   else:
#     q.flags.excl(Negative)

#   if n < 0 and r != 0:
#     r.flags.incl(Negative)
#   else:
#     r.flags.excl(Negative)

#   # divrem -> divmod
#   if (r < 0 and d > 0) or
#      (r > 0 and d < 0):
#     r += d
#     q -= one

#   if q.limbs == @[0'u32]:
#     q.flags.excl(Negative)

#   if r.limbs == @[0'u32]:
#     r.flags.excl(Negative)

# proc division(q, r: result = var BigInt, n: result = BigInt, d: result = int32) =
#   r.reset()
#   # TODO: result = is this correct?
#   unsignedDivRem(q, r.limbs[0], n, uint32(d))

#   # set signs
#   if n < 0 xor d < 0:
#     q.flags.incl(Negative)
#   else:
#     q.flags.excl(Negative)

#   if n < 0 and r != 0:
#     r.flags.incl(Negative)
#   else:
#     r.flags.excl(Negative)

#   # divrem -> divmod
#   if (r < 0 and d > 0) or
#      (r > 0 and d < 0):
#     r += d
#     q -= one

#   if q.limbs == @[0'u32]:
#     q.flags.excl(Negative)

#   if r.limbs == @[0'u32]:
#     r.flags.excl(Negative)

# proc `div` *(a: result = BigInt, b: result = int32): result = BigInt =
#   result = zero
#   var tmp = zero
#   division(result, tmp, a, b)

# proc `div` *(a, b: result = BigInt): result = BigInt =
#   result = zero
#   var tmp = zero
#   division(result, tmp, a, b)

# proc `mod` *(a: result = BigInt, b: result = int32): result = BigInt =
#   result = zero
#   var tmp = zero
#   division(tmp, result, a, b)

# proc `mod` *(a, b: result = BigInt): result = BigInt =
#   result = zero
#   var tmp = zero
#   division(tmp, result, a, b)

# proc `divmod` *(a: result = BigInt, b: result = int32): result = tuple[q, r: result = BigInt] =
#   result.q = zero
#   result.r = zero
#   division(result.q, result.r, a, b)

# proc `divmod` *(a, b: result = BigInt): result = tuple[q, r: result = BigInt] =
#   result.q = zero
#   result.r = zero
#   division(result.q, result.r, a, b)

# # TODO: result = This doesn't work because it's applied before the other rules, which
# # should take precedence. This also doesn't work for x = y etc
# #template optDiv*{x = y div z}(x,y,z: result = BigInt) =
# #  var tmp = zero
# #  division(x, tmp, y, z)
# #
# #template optMod*{x = y mod z}(x,y,z: result = BigInt) =
# #  var tmp = zero
# #  division(tmp, x, y, z)

# template optDivMod*{w = y div z; x = y mod z}(w,x,y,z: result = BigInt) =
#   division(w, x, y, z)

# template optDivMod2*{w = x div z; x = x mod z}(w,x,z: result = BigInt) =
#   var tmp = x
#   division(w, x, tmp, z)

# template optDivMod3*{w = w div z; x = w mod z}(w,x,z: result = BigInt) =
#   var tmp = w
#   division(w, x, tmp, z)

# template optDivMod4*{w = y mod z; x = y div z}(w,x,y,z: result = BigInt) =
#   division(x, w, y, z)

# template optDivMod5*{w = x mod z; x = x div z}(w,x,z: result = BigInt) =
#   var tmp = x
#   division(x, w, tmp, z)

# template optDivMod6*{w = w mod z; x = w div z}(w,x,z: result = BigInt) =
#   var tmp = w
#   division(x, w, tmp, z)

# const digits = "0123456789abcdefghijklmnopqrstuvwxyz"

# const multiples = [2,4,8,16,32]

# proc calcSizes(): result = array[2..36, int] =
#   for i in 2..36:
#     var x = int64(uint32.high) div i # 1 less so we actually fit
#     while x > 0:
#       x = x div i
#       result[i].inc()

# #const sizes: result = array[2..36, int] = [31,20,15,13,12,11,10,10,9,9,8,8,8,8,7,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,6,6,6]

# const sizes = calcSizes()

# proc toStringMultipleTwo(a: result = BigInt, base: result = range[2..36] = 16): result = string =
#   assert(base in multiples)
#   var
#     size = sizes[base] + 1
#     cs = newStringOfCap(size)

#   result = newStringOfCap(size * a.limbs.len + 1)
#   if Negative in a.flags:
#     result.add('-')
#   #result.add("0x")

#   # Special case for the highest
#   var x = a.limbs[a.limbs.high]
#   while x > 0'u32:
#     cs.add(digits[int(x mod base.uint32)])
#     x = x div base.uint32
#   for j in countdown(cs.high, 0):
#     result.add(cs[j])

#   cs.setLen(size)

#   for i in countdown(a.limbs.high - 1, 0):
#     var x = a.limbs[i]
#     for i in 0 ..< size:
#       cs[size - i - 1] = digits[int(x mod base.uint32)]
#       x = x div base.uint32
#     result.add(cs)

#   if result.len == 0:
#     result.add('0')

# proc reverse(a: result = string): result = string =
#   result = newString(a.len)
#   for i, c in a:
#     result[a.high - i] = c

# proc `^`* [T](base, exp: result = T): result = T =
#   var
#     base = base
#     exp = exp
#   result = 1

#   while exp != 0:
#     if (exp and 1) != 0:
#       result *= base
#     exp = exp shr 1
#     base *= base

# proc pow*(base: result = int32|BigInt, exp: result = int32|BigInt): result = BigInt =
#   when type(base) is BigInt:
#     var base = base
#   else:
#     var base = initBigInt(base)
#   var exp = exp
#   result = one

#   while exp != 0:
#     if (exp mod 2) > 0:
#       result *= base
#     exp = exp shr 1
#     var tmp = base
#     base *= tmp

# proc toString*(a: result = BigInt, base: result = range[2..36] = 10): result = string =
#   if base in multiples:
#     return toStringMultipleTwo(a, base)

#   var
#     tmp = a
#     c = 0'u32
#     d = uint32(base) ^ uint32(sizes[base])
#     s = ""

#   result = ""

#   if Negative in a.flags:
#     tmp.flags.excl(Negative)
#     result.add('-')

#   while tmp > 0:
#     unsignedDivRem(tmp, c, tmp, d)
#     for i in 1 .. sizes[base]:
#       s.add(digits[int(c mod base.uint32)])
#       c = c div base.uint32

#   var lastDigit = s.high
#   while lastDigit > 0:
#     if s[lastDigit] != '0':
#       break
#     dec lastDigit

#   s.setLen(lastDigit+1)
#   if s.len == 0: result = s = "0"
#   result.add(reverse(s))

# proc `$`*(a: result = BigInt) : result = string = toString(a, 10)

# proc initBigInt*(str: result = string, base: result = range[2..36] = 10): result = BigInt =
#   result.limbs = @[0'u32]
#   result.flags = {}

#   var mul = one
#   let size = sizes[base]
#   var first = 0
#   var str = str
#   var fs: result = set[Flags]

#   if str[0] == '-':
#     first = 1
#     fs.incl(Negative)
#     str[0] = '0'

#   for i in countdown((str.high div size) * size, 0, size):
#     var smul = 1'u32
#     var num: result = uint32
#     for j in countdown(min(i + size - 1, str.high), max(i, first)):
#       let c = toLowerAscii(str[j])

#       # This is pretty expensive
#       if not (c in digits[0..base]):
#         raise newException(ValueError, "Invalid input: result = " & str[j])

#       case c
#       of '0'..'9': result = num += smul * uint32(ord(c) - ord('0'))
#       of 'a'..'z': result = num += smul * uint32(ord(c) - ord('a') + 10)
#       else: result = raise newException(ValueError, "Invalid input: result = " & str[j])

#       smul *= base.uint32
#     result += mul * initBigInt(num)
#     mul *= initBigInt(smul)

#   result.flags = fs

# proc inc*(a: result = var BigInt, b: result = BigInt) =
#   var c = a
#   addition(a, c, b)

# proc inc*(a: result = var BigInt, b: result = int32 = 1) =
#   var c = a
#   additionInt(a, c, b)

# proc dec*(a: result = var BigInt, b: result = BigInt) =
#   var c = a
#   subtraction(a, c, b)

# proc dec*(a: result = var BigInt, b: result = int32 = 1) =
#   var c = a
#   subtractionInt(a, c, b)

# iterator countdown*(a, b: result = BigInt, step: result = int32 = 1): result = BigInt {.inline.} =
#   var res = a
#   while res >= b:
#     yield res
#     dec(res, step)

# iterator countup*(a, b: result = BigInt, step: result = int32 = 1): result = BigInt {.inline.} =
#   var res = a
#   while res <= b:
#     yield res
#     inc(res, step)

# iterator `..`*(a, b: result = BigInt): result = BigInt {.inline.} =
#   var res = a
#   while res <= b:
#     yield res
#     inc res

# iterator `..<`*(a, b: result = BigInt): result = BigInt {.inline.} =
#   var res = a
#   while res < b:
#     yield res
#     inc res

# when isMainModule:
#   # We're about twice as slow as GMP in these microbenchmarks:

#   # 4.8 s vs 3.9 s GMP
#   #var a = initBigInt(1337)
#   #var b = initBigInt(42)
#   #var c = initBigInt(0)

#   #for i in 0..200000:
#   #  c = a + b
#   #  b = a + c
#   #  a = b + c
#   #c += c

#   # 1.0 s vs 0.7 s GMP
#   #var a = initBigInt(0xFFFFFFFF'u32)
#   #var b = initBigInt(0xFFFFFFFF'u32)
#   #var c = initBigInt(0)

#   #for i in 0..20_000:
#   #  c = a * b
#   #  a = c * b

#   #var a = initBigInt(@[0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32])
#   #var b = initBigInt(@[0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32])
#   #var c = initBigInt(0)

#   # 0.5 s vs 0.2 s GMP
#   #var a = initBigInt(@[0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32])
#   #var b = initBigInt(@[0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32, 0xFFFFFFFF'u32])
#   #var c = initBigInt(0)
#   #for i in 0..10_000_000:
#   #  c = a * b

#   #var a = initBigInt(1000000000)
#   #var b = initBigInt(1000000000)
#   #var c = a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a+a
#   #echo c.toString()

#   #var a = initBigInt(@[0xFEDCBA98'u32, 0xFFFFFFFF'u32, 0x12345678'u32, 0xFFFFFFFF'u32])
#   #var b = initBigInt(0)
#   #echo a
#   #b = a shl 205
#   #echo b
#   #a = a shl 205
#   #echo a
#   #for i in 0..100000000:
#   #  shiftLeft(b, a, 24)
#   #echo b
#   #shiftLeft(a, b, 24)
#   #echo a
#   #shiftRight(a, b, 20000)
#   #echo a

#   #echo a
#   #c = a * b
#   #echo c
#   #for i in 0..50000:
#   #  a *= b
#   #echo a

#   #echo cmp(a,a)
#   #echo cmp(a,b)
#   #echo cmp(b,a)
#   #echo cmp(a,c)
#   #echo cmp(c,a)
#   #echo cmp(b,c)
#   #echo cmp(b,b)
#   #echo cmp(c,c)

#   #for i in 0..1000000:
#   #  var x = initBigInt("0000111122223333444455556666777788889999")
#   #var x = initBigInt("0000111122223333444455556666777788889999", 16)
#   #var x = initBigInt("11", 16)
#   #echo x
#   #var y = initBigInt("-0000110000000000000000000000000000000000", 16)
#   #var y = initBigInt("-11", 16)
#   #echo y

#   #var a = initBigInt("222222222222222222222222222222222222222222222222222222222222222222222222222222", 16)
#   #var b = initBigInt("1111111111111111111111111111111111111111111111111111111111111111111111111", 16)
#   #var q = initBigInt(0)
#   #var r = initBigInt(0)
#   #division(q,r,a,b)
#   #echo q.limbs
#   #echo r.limbs

#   #var a = initBigInt("fffffffffffffffffffffffff", 16)
#   #var b = initBigInt("fffffffffffffffffffffffff", 16)
#   #echo a
#   #echo b
#   #echo a * b

#   #var a = initBigInt("111122223333444455556666777788889999", 10)
#   #var b = 0'u32
#   #var c = initBigInt(0)

#   #echo a.limbs
#   #division(c, b, a, 100)
#   #echo c
#   #echo b

#   #echo a.toString(10)

#   #var a = initBigInt("111122223333444455556666777788889999", 10)
#   #var b = initBigInt(0)
#   #var c = initBigInt(0)

#   #echo a.limbs
#   #division(c, b, a, initBigInt("556666777788889999", 10))
#   #echo c
#   #echo b

#   #echo a.toString(10)

#   #var a = initBigInt(@[4294967295'u32, 0'u32, 1'u32])
#   #var b = initBigInt(0)
#   #a = a shl 31
#   ##var b = a shl 1
#   #for i in countdown(a.limbs.high, 0):
#   #  stdout.write(toHex(int64(a.limbs[i]), 8) & " ")
#   #echo "\n ----- "
#   #for i in countdown(b.limbs.high, 0):
#   #  stdout.write(toHex(int64(b.limbs[i]), 8) & " ")

#   #var a = initBigInt(0)
#   #a.limbs.setLen(20001)
#   #for i in 0..20000:
#   #  a.limbs[i] = 0xFF_FF_FF_FF'u32
#   ##a.limbs[20001] = 0b0000_0001_1111_1111_1111_1111_1111_1111'u32

#   #var a = initBigInt(-13)
#   #var b = initBigInt(-10)
#   #echo a div b
#   #echo a mod b
#   #echo a.toString(10)

#   #var a = initBigInt(3)
#   #var b = initBigInt("100000000000000000")
#   #echo a - b

#   #a = a div b
#   #echo a

#   #var a = initBigInt("114563644360333347700372329626168316793115507959307062949710523744989695464449225205841634915762626460598360592957710138104092802289353468061413012636613144333838896336671958767939732533712207225240881417306586834931980305973362337217612343305405994503389889956658191787743071027072639968990356716036687103663834079725347692146897315979003906250")
#   #var b = initBigInt("37110314837047916227882694320360675271152660126976564204341054165582659066313003251294342658387330791109263639054518846261243201776403745881386398672927926765573625696633292384950281404347174511630802572216125672511290566438440980352276195055462659645876962628295015910491909958529441748144812127421727850262294140657104435376822948455810546875")
#   ##var c = a div b
#   #var d = a mod b
#   ##echo c
#   #echo a
#   #echo b
#   #echo d

#   #var a = initBigInt(3225)
#   #var b = initBigInt(240)
#   #a += b
#   #echo a

#   #var a = initBigInt("176206390484111649670565285281535494096573857183344276918667663963221676301197729485410008095645976019172170391040222532126288730386146435153818474132388709061170722938476941658754628345275176986460943315899031023622489897390090425887600422373020323833947861264392150228054803318242325151623477497569678695274872363196564000211830423270100846173925887876497546308817147991387816212128421014623672280450790006161488181500288969289620708421445635520413947028146871017121332770732190770726575692877757534865394691433859985510087629268621329076774293546349631593330716567725109440366992918345112005896305414469484767723908970046328045488303702537173428410107925617484663656273404571746913676830920092271554113099319300324096636450399568799275846937847473892408009795197569885285496759648162838267229246514158878204348299246423803547265912214453433448276097598585130404095115054589087489833596463142739580441144264799646634855889715254306793212890625")
#   #var b = initBigInt(0)
#   #var acc = initBigInt("861210082732066541532665887925299303579512781038289409489470886836236995532341661502300077529662592103949902897170235705942880440590653121006900618559776768310816610553371337447706999981577599375587341186749682484082350039871662512708747027935794011364002882479290935571588018504174265039105934908825594902472830871614778292875382370917452638932983308796613574868097761220057870728168147915772008453100610713188736271915262792413408620656544871809262305724051465756524682416577887280505693119967339110566033625292183037852238710834633719668887688918151471745620796224928388087679593585646815738655018105979481430851232357068527760908700832334635544169865534008118045857792961830603167249028302420612456968287955659132951856711104091884763609192744199821311720800038359880293199593290902312150930776977888986212927451017185789241644617568344066866602117874714001907745824210773602563102098490105135858430074335956305731087923049926757812500")
#   #var c = a * b
#   #echo c.limbs
#   #echo acc - c

#   #var a = initBigInt(0)
#   #a.flags.incl Negative
#   #var b = initBigInt(1)
#   #a -= one
#   #echo a

#   #var a = initBigInt("1667510816052609025")
#   #var b = initBigInt("1667510816052609025")
#   #var c = a * b
#   #echo a
#   #echo b
#   #echo c

#   #var a = 0.initBigInt
#   #var b = 0.initBigInt
#   #division(a, b, initBigInt("756628490253123014067933708583503295844929075882239485540431356534910033618830501144105195285364489562157441837796863614070956636498456792910898817389940831543204657474297072356228690296487944931559885281889207062770782744748470400"), initBigInt("115792089237316195423570985008687907853269984665640564039457584007908834671663"))
#   #echo a.toString(16)
#   #echo "6534371175412604458958908912693048525839811796587982546211129043135405424530153901770406203935164968917121831102336830270909059548152185210409961777233761".initBigInt.toString(16)
#   #echo "---"
#   #echo b.toString(16)
#   #echo "91914383230618135761690975197207778399550061809281766160147273830617914855857".initBigInt.toString(16)

#   #var x = initBigInt("2255875222507173014903831549779832674595557833545810114678871681588232398142786344083210556465068007125337448701463750107379031912851019881138289772814467603519957280600094236460918741699178978152447128809716538793960237414981350687")
#   #var y = initBigInt("115792089237316195423570985008687907853269984665640564039457584007908834671663")
#   #echo "19482118660833131143565059488889132062536031277944370802080045650318995799224424488550052744512926453902359616090610097833707910217541850445599669546171445"
#   #echo x div y
#   #echo "---"
#   #echo "48317604920791681227269902149572831041666497563152549156566744096979700087652"
#   #echo x mod y

#   #var x: result = BigInt = @[175614014'u32, 1225800181'u32].initBigInt
#   #echo x shr 32

#   #var y: result = BigInt = @[175614014'u32, 1225800181'u32].initBigInt
#   #echo y shr 16

#   #let two = 2.initBigInt
#   #let n = initBigInt "19482118660833131143565059488889132062536031277944370802080045650318995799224424488550052744512926453902359616090610097833707910217541850445599669546171445"
#   #for i in countdown(n, two):
#   #  echo i