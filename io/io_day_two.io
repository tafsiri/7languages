#Q1. write code to compute a fibonnaci sequence
#A1. Did this on day one :)

#Q2. How would you change '/' to return 0 if the denominotor is zero?
#    (it currently returns inf in Io)
Number div := Number getSlot("/")
Number / = method(divisor,
  if(divisor == 0
    , 0
    , div(divisor)
    )
  )
  
r := 4 / 0
r println

#Q3. Write a program to add up all the numbers in a two dimensional array

2d := list(list(1,2,3),
           list(4,5,6),
           list(7,8,9))
           
sum2d := method(arr,
  sum := 0
  arr foreach(innerList, 
    innerList foreach(value, sum = sum + value)
    )
  sum
  )

sum2d_b := method(arr,
  sum := 0
  arr foreach(innerList, 
    sum = sum + innerList sum
    )
  sum
  )
  
sum2d(2d) println
sum2d_b(2d) println

#Q4. Add a slot called myAverage to a list that computes the average of all the numbers
#    in a list, what happens if there are no numbers. Raise an exception if 
#    there is a non-number in the list

List myAverage := method(
  self sum / self size
  )
  
l := list(1,2,2,4,5)
l myAverage println  #will throw an exception if there are no numbers in the list

bl := list(1,2,"bananas",4,5)
#bl myAverage println  #will throw an exception (different than the one above)

List mymyAverage := method(
  sum := 0
  self foreach(v,
      if v.proto != Number
       , Exception raise("You must pass a number into mymyAverage. I don't parse strings either!")
       , sum = sum + v
    )
   sum / self size
  )

bbl := list(1,2,"bananas",4,5)
#bbl mymyAverage println  #will throw my exception

#Q5  Write a prototype for a two-dimensional list.
#    dim(x,y) should allocate a list of y lists that are x elements long
#    implement set(x,y) and get(x,y)
"\n" println
Table := Object clone

Table dim := method(length, height,
  self _length := length
  self _height := height
  self _data := list setSize(length)
  for(i, 0, _data size - 1 , 1,
      _data atPut(i, list setSize(height))
    )
  )
  
Table print := method(
  "" println
  for(i, 0, _data size - 1 , 1,
      _data at(i) println
    )
  "" println
  )

Table set := method(x, y, val,
  if(x > _length or y > _height
    , Exception raise("Out of bounds")
    , self _data at(x) atPut(y, val)
    )
  )

Table get := method(x, y,
  if(x > _length or y > _height
    , Exception raise("Out of bounds")
    , _data at(x) ?at(y)
    )
  )
  
table := Table clone
table dim(3,2)
table get(0,0) # 2> nil
table set(0,0,1)
table set(0,1,1)
table get(0,0) # => 1
table print

#Q6 Write a transpose method for the two dimensional list above

Table transpose := method(
  other := Table clone
  other dim(self _height, self _length)
  
  for(i, 0, _length - 1 , 1,
      for(j, 0, _height - 1 , 1,
         other set(j,i, get(i,j))
        )
    )
  return other
  )
  
t2 := table transpose
t2 print
(t2 get(0,1) == table get(1,0)) #=> true

#Q7 Write the matrix to a file

Table printToFile := method(file,
  for(i, 0, _data size - 1 , 1,
      file write(_data at(i) asString)
      file write("\n")
    )
  )

f := File with("day2_out.txt")
f openForUpdating
t2 printToFile(f)
f close