#traditional recursive fib
fib := method(num,
  if(num == 0 or num == 1
    , num
    , fib(num-1) + fib(num-2)
  )
)

#tail recursive fib
fibtail := method(num,
  fibhelp := method(num, a1, a2,
    if(num == 0
      , a1
      , fibhelp(num - 1, a2, a1 + a2)
    )
  )
  fibhelp(num, 0, 1)
)

#iterative fib
fibiter := method(num,
  fib   := 0
  count := 0
  f1   := 0
  f2   := 1
  while(count < num-1,
    fib = f1 + f2
    f1 = f2
    f2 = fib
    count = count + 1
  )
  fib
)

#fib with memoization
fakeClosure := Object clone
fakeClosure memo := Map clone
fakeClosure fibmemo := method(num,
  #I need this next line when i assign this method to a slot in the
  #outer object (see line 61 and the call on line 67), feels like a
  #'this/self' binding issue.
  memo := fakeClosure memo 
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
)
#not really necessary, but i wanted it to be uniform with the other calls
fibmemo := fakeClosure getSlot("fibmemo")

num := 6
a0 := fib(num)
a1 := fibtail(num) 
a2 := fibiter(num)
a3 := fibmemo(num)

writeln("Fib results")
writeln(a0)
writeln(a1)
writeln(a2)
writeln(a3)

writeln("")
#differential inheritance
#making types (objects with a type field)
Shape := Object clone
Shape area := method(width * height)
Shape width := 5
Shape height := 9
Rect := Shape clone
Square := Shape clone
Ellipse := Shape clone

#making objects (without a type field, not the lowercase start
#to the variable name)
box := Rect clone 
boxyBox := Square clone 
egg := Ellipse clone

#
writeln("Differential inheritance")
box slotNames println         # => list()
boxyBox slotNames println     # => list()
egg slotNames println         # => list()

Rect slotNames println        # => list(type)
Square slotNames println      # => list(type)
Ellipse slotNames println     # => list(type)
Shape slotNames println       # => list(height, type, width, area)

#seems like hasSlot will crawl up the inheritance tree
box hasSlot("area") println # => true