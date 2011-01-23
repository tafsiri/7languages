#The sleeping barber problem http://en.wikipedia.org/wiki/Sleeping_barber_problem
#Solved with Io actors

Barber := Object clone do(
  sleeping := false
  
  wakeup := method(
    "Waking Up!" println
    sleeping = false
  )
  
  sleep := method(
    "Going to sleep" println
    sleeping = true
  )
  
  cutHair := method(customer, inWaitingRoom,
    if(sleeping == true, wakeup)
    #remove them from the waiting room
    if(inWaitingRoom
      , WaitingRoom releaseSeat(customer)
    )
    
    ("Cutting the hair of " .. customer name) println
    wait(0.2 + Random value(0,1))
    "done"
  )
  
  work := method(
    if(WaitingRoom empty and sleeping == false, sleep)
  )

)

WaitingRoom := Object clone do(
  chairs := 3
  chairs_left := chairs
  empty := method(chairs_left == chairs)
  hasSpace := method(chairs_left > 0)
  takeSeat := method(customer,
    if(hasSpace
      , chairs_left = chairs_left - 1
        (customer name .. ": taking a seat in the waiting room. " .. chairs_left .. " left") println
        true
      , false
    )
  )
    
  releaseSeat := method(customer,
    chairs_left = chairs_left + 1
    (customer name .. ": leaving a seat in the waiting room. " .. chairs_left .. " left") println

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
    if(state == "sad" , (name .. ": is leaving and didn't get a haircut :-(") println)
    if(state == "happy" , (name .. ": is leaving and got a great haircut :-)") println)
  )
  
  gotoBarber := method(
    currentCoro setLabel(name)
    #wait a random amount of time before going to the barber
    wait(Random value(0,4))
    (name .. ": going to the barber!") println
    takeSeatOrLeave()
  )
) 

numCustomers := 10
if(System args size > 1, numCustomers = System args at(1) asNumber)
for(i, 1, numCustomers , 1,
  c := Customer clone
  c init("c" .. i)
  c @@gotoBarber
)

"Go!" println
while(true,
  Barber @@work
  #not sure why, but i need both yield and wait in order
  #for this loop not to peg my cpu
  yield
  wait(1)
  #Scheduler yieldingCoros size println
)