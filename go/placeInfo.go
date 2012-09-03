package main

import (
  "os"
  "io"
  "log"
	"fmt"
	"strconv"
	"encoding/csv"
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
  
  reader := csv.NewReader(file)
  reader.Comma = '\t' //tab seprated file
  
  linesSkipped := 0 //keep track of lines with errors
  //for { } === while(true) { }
  for {
    nextLine, err := reader.Read()
    if err == io.EOF {
      break
    }

    if err == nil {
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