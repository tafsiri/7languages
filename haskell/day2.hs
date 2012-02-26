module Main where
-- Q1 Write a function to sort a list
  
  --Trying out bubble sort just to see how i would approach it in haskell
  --recursve sorts like quicksort would likely be more natural to express
  
  --helper function does one iteration of the bsort algorithm
  bsorthelper [] = []
  bsorthelper [a] = [a]
  bsorthelper lst = let
    (f:s:rest) = lst
    in if f < s
      then
        (f:bsorthelper (s:rest))
      else
        (s:bsorthelper (f:rest))

  --bsort function. So named not because of bubble sort's reputation, but rather because this implementation
  --always iterates over a list of length n, n times, thus even reducing bubble sorts decent performance
  --on nearly sorted lists. Didn't feel like keeping track of the status of the list in the helper
  --at the moment. May come back to this in future
  bsortstupid lst = last (take (length lst) (iterate bsorthelper lst))
  
  -- Quicksort implementation, it indeed feels much more natural than bsort.
  qsort [] = []
  qsort [a] = [a]
  qsort lst = let
    --take the middle element of the list as the pivot
    (f, s) = splitAt (floor (fromIntegral (length lst) / 2)) lst
    pivot = head s
    withoutpivot = f ++ (tail s)
    --gather the sublists
    left = [ el | el <- withoutpivot, el <= pivot ]
    right = [ el | el <- withoutpivot, el > pivot ]
    -- do the recursive call to quicksort in the return value
    in (qsort left) ++ [pivot] ++ (qsort right)
    
-- Q2 Write a sort that takes a list and a function that compares its two arguments and returns a
-- sorted list
  
  sortBy :: [a] -> (a -> a -> Bool) -> [a]
  sortBy [] _ = []
  sortBy [a] _ = [a]
  sortBy lst comparator = let
    -- just going to use the qsort code above by with a custom comparator
    -- this function assmes the comparator is of a -or-equals-to nature and
    -- returns a boolean
    (f, s) = splitAt (floor (fromIntegral (length lst) / 2)) lst
    pivot = head s
    withoutpivot = f ++ (tail s)
    --gather the sublists
    left = [ el | el <- withoutpivot, comparator el pivot ]
    right = [ el | el <- withoutpivot, not (comparator el pivot) ]
    -- do the recursive call to quicksort in the return value
    in (sortBy left comparator) ++ [pivot] ++ (sortBy right comparator)
  
  --usage (will sort descending according to anon function passed in)
  sorted = sortBy [8,7,6,5,4,5,4,3] (\a b -> a >= b)
  
-- Q3 Write a function that converts a string to a numerical type. The string is in the form
-- $2,345,678.99 and can have leading zeroes.

  -- I'm not going to be doing error checking on the format btw
  
  strToNum :: Fractional a => [Char] -> a
  strToNum str = let
    -- remove the '$' and ','
    plain = filter (\x -> x /= '$' && x /= ',') str 
    whole =  takeWhile (\x -> x /= '.') plain
    fractional = tail (dropWhile (\x -> x /= '.') plain)
    in (strToNumWhole whole) + (strToNumFrac fractional)
  
  -- helper functions
  
  strToNumWhole :: Num a => [Char] -> a
  strToNumWhole str = let
    -- use a zip to combine the individual chars with the index of their position
    -- we will use the index to multiply 10s, 100s, 1000s, etc
    -- produces a list of tuples like [("2", 0), ("1"), 1] from the string "12"
    withIndices = zip (reverse str) [0..]
    in sum (map (\pair -> (digitToNum (fst pair)) * (10 ^ snd pair)) withIndices)
  
  strToNumFrac :: Fractional a => [Char] -> a
  strToNumFrac str = let
    withIndices = zip (str) [1..]
    in sum (map (\pair -> (digitToNum (fst pair)) /  (10 ^ snd pair)) withIndices)
    
  digitToNum :: Num a => Char -> a
  digitToNum '0' = 0
  digitToNum '1' = 1
  digitToNum '2' = 2
  digitToNum '3' = 3
  digitToNum '4' = 4
  digitToNum '5' = 5
  digitToNum '6' = 6
  digitToNum '7' = 7
  digitToNum '8' = 8
  digitToNum '9' = 9
  
  
-- Q4 Write a function that takes an argument x and returns a lazy sequence that has
-- every third number, starting with x. Then write a second function that includes every fifth
-- number beginning with y. Combine these functions through composition to return every eighth 
-- number beginning with x + y.
  
  -- sooooo... the first solution to the first two was kind of given in the book (the myrange
  -- function) and i don't fully get the third part. From what i understand about function composition
  -- the return type of first function must match the argument type of the second function in the chain
  -- this makes complete sense; if f . g = \x -> f (g x), the (g x) must result in something f can take
  -- in this case both functions takes a number but returns a sequence. This sequence cannot be an
  -- input to the second function. I am not sure this question is well formulated.
  
  -- One could use zip to combine the output of these functions (which would produce the result
  -- requested), however that is not function composition.
  
  everyN step start = start:(everyN step (start + step))
  
  every3rd = everyN 2
  every5th = everyN 4
  
-- Q5 Use a partially applied function to define a function that will return half of a number and 
-- another that will append \n to the end of the any string. (My interpretation of this question:
-- generate the required output using a partially applied function. Its written in a strange /ambigous
-- way).

  divider divisor dividend = dividend / divisor
  halfer = divider 2
  
  halferTwo = (/ 2) -- or just partially apply the div operator
  
  appender toAppend input = input ++ toAppend
  newliner = appender ['\n']
  
  newlinerTwo = (++ ['\n']) -- or just partially apply the ++ operator
