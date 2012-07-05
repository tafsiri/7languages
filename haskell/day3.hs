module Main where
  -- Q1. Write a function that looks up a hash table value that uses the Maybe Monad. (IMHO this 
  -- question is kinda sloppily written, does the hash table use the maybe monad or the function?).
  -- Write a hash that stores other hashes, several levels deep. Use the Maybe monad to retrieve 
  -- an element several levels deep. (wtf does this even mean? is the maybe monad going to do the 
  -- retrieving for me?)
  
  -- What I am going to attempt to do (my interpretation of the above):
  --  1. Write a function that looks up a value by key (in a collection of key value pairs)
  --     and returns a result wrapped in the Maybe monad. 
  --  2. Write a function that can look for a value in a list of (posibly) nested key-value pair collections
  --     returning results wrapped in a maybe
  --  Note: I do know that haskell has a Data.Map type, i am just assuming we are not supposed to use
  --  it for pedagogical reasons.
  
  hash = [('a', "apple"), ('b', "bear"), ('c', "cat"), ('d', "dog")]
  
  find :: Eq a => [(a, b)] -> a ->  Maybe b
  find [] _ = Nothing
  find tuples key = let
    (nextKey, nextVal) = head tuples
    rest = tail tuples
    in
      if key == nextKey then Just nextVal else find rest key
  
  -- Final iteration of first failed attempt at Q2. (This does not work)
  -- I think ultimately i could not satisfy the typechecker that the operations on
  -- my recursive type would work out, without actually specifying a custom recursive type. (below)
  -- this approach would also have gone though the entire hash no matter when a hit was found
  
  -- nestedHash = [("english", [("one", ["un"]), ("two", ["deux"])]), ("french", [("un", ["one"]), ("deux", ["two"])])]
  
  -- findDeep [] _ = [Nothing]
  -- findDeep list key
  --   | list == [] = [Nothing]
  --   | otherwise = let
  --     ft = head list
  --     kids = (snd ft)
  --     in if key == (fst ft) then [Just (snd ft)] else findDeep (tail list) key ++ findDeep kids key
  

  -- This non-random assortment of non functioning code is as far as i got in a second attempt at Q.2
  -- where i try to define my own types. This code is almost certainly horrible and the wrong way to go
  -- about this, so i'm going to put myself out of my own misery and defer to a time when i can actually 
  -- learn the language properly instead of taking wild stabs in the dark and reading snippets
  -- of language tutorials.

  data HashCell = HS (String, String) | HN (String, NestedHash)  deriving (Show)
  type NestedHash = [HashCell]
  --need the following just for the return type of findIn
  data HashVal = HVS String | HVN NestedHash deriving (Show)

  
  key :: HashCell -> String
  key (HS (key, _)) = key
  key (HN (key, _)) = key
  
  sval :: HashCell -> String
  sval (HS (_, val)) = val
  
  nval :: HashCell -> NestedHash
  nval (HN (_, val)) = val
  
  findIn :: NestedHash -> String -> Maybe HashVal
  findIn ns@(h:t) target = Nothing
  -- the plan here was to check the type of each cell and then call one of the two helper functions
  -- below. One of which can call back to this function if needed. I've just lost the desire to complete
  -- this.
    
  -- helper for checking for the key in a non nested cell  
  findInSimple :: HashCell -> String -> Maybe HashVal
  findInSimple (HS (key, val)) target = 
    if key == target then Just (HVS val) else Nothing
  
  -- helper for checking for the key in a nested cell
  findInNested :: HashCell -> String -> Maybe HashVal
  findInNested (HN (key, val)) target = 
    if key == target then Just (HVN val) else findIn val target
  
  
  -- test data
  english = HN ("english",  [ HS ("one", "un"), HS ("two", "deux")])
  french = HN ("french", [ HS ("un", "one"), HS ("deux", "two")])
  nestedHash = [english, french]