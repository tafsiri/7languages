#Minimal mixins in Io!
Object mix := method(obj,
  #grab all the objects methods and add them to the target
  #the target is the object mixing in the mixin
  mixer := call target
  obj slotNames foreach(slotName,
    if(obj getSlot(slotName) type == "Block"
        , mixer setSlot(slotName, obj getSlot(slotName))
        #ignore properties for the moment
      )
    )
  )

Comparator := Object clone do(
  < := method(other,  compareTo(other) < 0)
  > := method(other,  compareTo(other) > 0)
  == := method(other, compareTo(other) == 0)
  )

StrangeNum := Object clone do(
  mix(Comparator)
  
  #for some bizzare reason we want to sort by the squares of [value]
  compareTo := method(other,
     value squared compare(other value squared)
    )
  )

low := StrangeNum clone
low value := 2
high := StrangeNum clone
high value := -3

(high value < low value) println    # => true
(high < low) println                # => false, uses our compareTo method