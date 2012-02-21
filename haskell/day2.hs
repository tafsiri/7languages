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

  --bsort function. So named not because bbble sort is bad, but rather because it always
  --iterates over a list of length n, n times, thus even losing bubble sorts decent performance
  --on nearly sorted lists. Didn't feel like keeping track of the status of the list in the helper
  --atm. May come back to this in future
  bsortstupid lst = last (take (length lst) (iterate bsorthelper lst))
  
  -- Quicksort implementation
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
  
  
