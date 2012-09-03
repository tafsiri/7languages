package main

import (
  "os"
  "io"
  "log"
	"fmt"
	"strconv"
	"strings"
	"bufio"
)

//Use a struct to store info about a place.
type PlaceInfo struct{
  Name  string
  Population int64
}

func main(){
  printLargest()
}

func printLargest(){
  //Open the csv and go through the entries, check the population of the highest one
  //and output it
  
  var largestPlace PlaceInfo
  
  file, err := os.Open("data/allCountries.txt") 
  if err != nil {
  	log.Fatal(err)
  }
  defer file.Close()
  
  //Make a buffered reader to read from the file
  bf := bufio.NewReader(file)
  
  linesSkipped := 0 //keep track of lines with errors
  for {
    line, _, err := bf.ReadLine()
    nextLine := strings.Split(string(line), "\t")
    
    if err == io.EOF {
      break
    }

    //Some of the lines are malformed and we want to skip them
    if err == nil && len(nextLine) == 19{
      population, err := strconv.ParseInt(nextLine[14], 10, 64)
      if err != nil {
        log.Fatal("Could not parse population as an int: " + nextLine[1])
      }
    
      if population > largestPlace.Population{
        largestPlace.Population = population
        largestPlace.Name = nextLine[1]
      }
      
    } else {
      //data is messy, keep track of how many lines skipped
      //log.Print("Error. Num Lines: ", "Msg: ", len(nextLine), err)
      linesSkipped += 1 
    }
    
  }
  fmt.Println("Lines Skipped:", linesSkipped)
  fmt.Println(largestPlace)
  
}