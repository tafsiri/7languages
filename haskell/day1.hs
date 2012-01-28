module Main where
  -- Q1. How many different ways can you write the function allEven?
  -- allEven using built in higher order functions
  ae1 :: [Integer] -> Bool
  ae1 x = all even x
  
  -- allEven with recursion
  ae2 [] = True
  ae2 (h:t) = if even h then ae2 t else False
  
  -- Longer form of the above with guards and a let expression
  ae3 list
    | list == [] = True
    | otherwise = 
      let
        h = head list
        t = tail list
        in if even h then ae3 t else False
    
  -- Q2. Write a function that takes a list and returns it in reverse
  -- with guards
  rev list
    | list == [] = []
    | otherwise =
      let
        h = head list
        t = tail list
        revtail = rev t
        in revtail ++ [h]
  
  -- without guards
  rev2 [] = []
  rev2 list = let
    h = head list
    t = tail list
    revtail = rev t
    in revtail ++ [h]

  -- pattern match in the let expression
  rev3 [] = []
  rev3 list = let
    (h:t) = list
    revtail = rev t
    in revtail ++ [h]
  
  -- pattern match sooner (in the pattern matcher :)
  rev4 [] = []
  rev4 (h:t) = let
    revtail = rev t
    in revtail ++ [h]
    
  --pattern match two liner (just a shorter version of above)
  rev5 [] = []
  rev5 (h:t) = rev4(t) ++ [h]
    
    
  -- Q3. Write a function that builds 2-tuples with all possible combinations of two of the
  -- colors black, white, blue, yellow and red. Note you should only include one of (black, blue)
  -- and (blue, black)
  
  -- uh huh, you know what it is... [a list comprehension]
  wiz_khalifa list = [ [fc, sc] | fc <- list, sc <- list, fc < sc ]
  -- usage wiz_khalifa["black", "white", "blue", "yellow", "red"]
  
  -- Q4. Write a list comprehension to procude a childhood multiplication table
  
  timestable = [ (fn, sn , fn * sn) | fn <- [1..12], sn <- [1..12] ]
  
  -- Q5 Solve the map coloring problem using Haskell (this problem is solved in Prolog in section 4.2)
  -- http://en.wikipedia.org/wiki/Graph_coloring
  -- http://en.wikipedia.org/wiki/Four_color_theorem
  
  