// Write a program that gives you ten guesses to guess a random number between 1-100. 
//   Give a hint of hotter or colder after the first guess 
targetNum := Random value(1,100) round
numGuesses := 10
prevGuess := nil
stdin := File standardInput
writeln("target = " .. targetNum asString)
while(numGuesses > 0,
  #get input
  writeln("Input your guess (integers between 1 and 100) - " .. numGuesses .. " guesses remaining")
  guess := stdin readLine("") asNumber #empty string passed as param to readline is the prompt it would display by default.
  if(guess == targetNum,
    writeln("Correct! You Win")
    System exit)
  if(prevGuess != nil and prevGuess != guess
    , if((targetNum - prevGuess) abs < (targetNum - guess) abs
      , writeln("colder")
      , writeln("warmer"))
    )
  prevGuess = guess
  numGuesses = numGuesses - 1
  )
writeln("Out of guesses.")
