#Create a list syntax that uses square brackets
Object squareBrackets := method(
  #simply return the *list* of arguments passed in
  call evalArgs
  )
  
#l := [1,2,3,4,5]
l := ["one", "two", "three", "four", "five"]
l type println    # => list
l at(1) println   # => 2
l at(1) type println

#define a square brackets index syntax on lists
List squareBrackets := method(index,
  self at(index)
  )
  
l[4] println # => 5

#Actors
#this code is from day 2
Delay := Object clone
Delay send := method(
  args := call message arguments
  for(i,0, args size - 1, 2,
    delay := doMessage(args at(i)) #do message turns the unevaluated '2' message into a '2' number
    msg := args at(i+1)

    wait(delay)
    msg doInContext(call sender) #thought i'd be able to do 'call sender msg' but that does not work
    )
  )


Me := Object clone
Date asString("%H:%M:%S") println
#"Hello There! the time is " ..
Me time := method(at, "Hello There! the time is " .. at asString("%H:%M:%S") println)
Me delayMsgs := method(Delay send(1, time(Date now), 
                                  3, time(Date now),
                                  5, time(Date now)))

Me @@delayMsgs  #note the @ symbol is the only thing we added to this snippet of code from day 2
#now the previous line returns immediately and we can do other things. In this case 
#we just wait (so that we can see the output from the delay. However we could do other things)
wait(10)