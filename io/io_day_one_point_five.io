#exploring iterating through list and map data-structures in Io

l := list(1,2,3,4,5,6)
l foreach(index, value, value println)
l foreach(value, value println)
l foreach(println) #send param as a message to each elem of l

l map(value, value * value)
l map(index, value, value * value)
l map(*3)

m := Map clone
m atPut("clementine", "orange")
m atPut("banana", "yellow")
m atPut("orange", "orange")
m atPut("apple", "red")
m atPut("strawberry", "red")
m atPut("blueberry", "blue")

writeln("")

vowels := list("a","e","i","o","u")

m foreach(k,v,
  pref := if(v exSlice(0,1) in(vowels), "An", "A")
  writeln(pref .. " " .. k .. " is " .. v)
  )

writeln("")
  
printFruit := method(fruit,col, 
  pref := if(fruit exSlice(0,1) in(vowels), "An", "A")
  writeln(pref .. " " .. fruit .. " is " .. col)
)

m foreach(k,v, printFruit(k,v)) #does the same as above
m map(k,v, printFruit(k,v))

writeln("")

#Blocks vs methods - fibmemo from io_day_one.io
#fib with memoization

fakeClosure := Object clone do(
  memo := Map clone
  fibmemo := block(num, #note 'blocks' are lexically scoped
    memo atPut(0 asString, 0)
    memo atPut(1 asString, 1)
    fibhelp := method(num,
      one := memo at((num-1) asString)
      two := memo at((num-2) asString)
      if(one == nil
        , one = fibhelp(num-1,memo)
          memo atPut((num-1) asString, one)
        )
      if(two == nil
        , two = fibhelp(num-2,memo)
          memo atPut((num-2) asString, two)
        )
      one + two
    )
    fibhelp(num,memo)
  ) setIsActivatable(true)
)

fibmemo := fakeClosure getSlot("fibmemo")
fibmemo(12) println 

#get rid of the object and just use a method as a container
fibmemoclosure := method(num,
  memo := Map clone
  fibmemo := block(num, #note 'blocks' are lexically scoped
    memo atPut(0 asString, 0)
    memo atPut(1 asString, 1)
    fibhelp := method(num,
      #memo asJson println
      one := memo at((num-1) asString)
      two := memo at((num-2) asString)
      if(one == nil
        , one = fibhelp(num-1,memo)
          memo atPut((num-1) asString, one)
        )
      if(two == nil
        , two = fibhelp(num-2,memo)
          memo atPut((num-2) asString, two)
        )
      one + two
    )
    fibhelp(num,memo)
  )
  return fibmemo
) call setIsActivatable(true)


fibmemoclosure(12) println
