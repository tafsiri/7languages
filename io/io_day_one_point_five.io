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
