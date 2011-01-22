#The sleeping barber problem http://en.wikipedia.org/wiki/Sleeping_barber_problem
#Solved with Io actors

happyCount := 0
sadCount := 0

Barber := Object clone do(
  init := method(
    self sleeping := true
  )
  
  sleeping := method(
    self sleeping
    )
  
  wakeup := method(
    "Waking Up!" println
    sleeping = true
  )
  
  sleep := method(
    "Going to sleep" println
    sleeping = false
  )
  
  cutHair := method(customer, inWaitingRoom,
    #remove them from the waiting room
    if(inWaitingRoom
      , WaitingRoom releaseSeat(customer)
    )
    
    ("Cutting the hair of " .. customer name) println
    wait(0.2 + Random value(0,1))
    "done"
  )
)

WaitingRoom := Object clone do(
  chairs := 3
  chairs_left := 3
  
  hasSpace := method(chairs_left > 0)
  takeSeat := method(customer,
    if(hasSpace
      , chairs_left = chairs_left - 1
        (customer name .. ": taking a seat in the waiting room") println
        true
      , false
    )
  )
    
  releaseSeat := method(customer,
    (customer name .. ": leaving a seat in the waiting room") println
    chairs_left = chairs_left + 1
  )
)
  
Customer := Object clone do(
  init := method(p_name,
    self name := p_name
    "Hi, my name is " .. name
  )
  
  
  takeSeatOrLeave := method(
    if(WaitingRoom takeSeat(self) == true
      , requestHaircut(true)
      , leave("sad")
    )
  )
    
  requestHaircut := method(inWaitingRoom,
    result := Barber @cutHair(self, inWaitingRoom)
    while(result != "done", yield) #this will block the current coroutine (and automatically yield)
    leave("happy")
  )
    
  leave := method(state,
    if(state == "sad"
      , (name .. ": is leaving and didn't get a haircut :-(") println
        Object sadCount = Object sadCount + 1
    )
    if(state == "happy"
      , (name .. ": is leaving and got a great haircut :-)") println
        Object happyCount = Object happyCount + 1
    )
  )
  
  gotoBarber := method(
    currentCoro setLabel(name)
    wait(Random value(0.1,2))
    (name .. ": going to the barber!") println
    takeSeatOrLeave()
  )
) 



for(i, 1, 10 , 1,
  c := Customer clone
  c init("c" .. i)
  c @@gotoBarber

  )
"Go!" println

while(true,
  #Coroutine showYielding
  yield#(1)
)
#while(Scheduler yieldingCoros size > 1, yield)
("Happy: " .. Object happyCount) println
("Sad: " .. Object sadCount) println
