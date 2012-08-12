//Pinstats.
//Fetch the pinterest front page. Extract all the name elements
//and keep track of the gender of what you find

package main

import (
	"code.google.com/p/go-html-transform/html/transform"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
	"time"
)

func main() {
  startTime := time.Now()
	//Load our name databases
	male := loadNames("male.names")
	female := loadNames("female.names")

	//Fetch the pinterest front page
	pageContent, _ := getFrontPage()
	
	//Extract the names of the people pinning and those liking the pins
	pinners := getPinners(pageContent)
	likers := getPinCommenters(pageContent)

	//Put the first names of all into one list.
	//Go doesn't seem to have a builtin list concat function.
	firstNames := []string{}
	for i := range pinners {
		firstNames = append(firstNames, strings.Split(pinners[i], " ")[0])
	}
	for i := range likers {
		firstNames = append(firstNames, strings.Split(likers[i], " ")[0])
	}
	
	//Test the names with our primitive gender guesser
	
	//We will store the names for each match (or lack thereof) in a map of lists
	results := map[string] []string {
	  "Male": []string{}, 
	  "Female": []string{}, 
	  "Unisex": []string{}, 
	  "Undetermined": []string{},
	}
	
	//Test if a name is male, female, both or unknown
  for _, name := range firstNames {
    isMale := false
    isFemale := false
    name = strings.ToUpper(name)
  
    if male[name] {
      isMale = true
    }
    if female[name]{
      isFemale = true
    }
    
    switch{
    case isMale && isFemale:
      results["Unisex"] = append(results["Unisex"], name)
    case isMale:
      results["Male"] = append(results["Male"], name)
    case isFemale:
      results["Female"] = append(results["Female"], name)
    case true:
      results["Undetermined"] = append(results["Undetermined"], name)
    }
  }
  
  //Print out results
  endTime := time.Now()
  fmt.Println("Results at", time.Now(), "Computed in", endTime.Sub(startTime))
  fmt.Println(len(results["Female"]), " Women")
  fmt.Println(len(results["Male"]), " Men")
  fmt.Println(len(results["Unisex"]), " Unisex names:", results["Unisex"])
  fmt.Println(len(results["Undetermined"]), " Undetermined:", results["Undetermined"])
}

//Loads the names in the file [fp] into a map. It assumes that 
//each name is the first token (before a space) on each line.
//This will thus not work on first names with spaces in them
func loadNames(fp string) map[string]bool {
	buffer, _ := ioutil.ReadFile(fp)
	lines := strings.Split(string(buffer), "\n")

	names := map[string]bool{}
	for _, line := range lines {
	  name := strings.Trim(strings.Split(line, " ")[0], " ")
		names[name] = true
	}
	return names
}

//Get the names of people who commented on a pin
func getPinCommenters(html string) []string {
	doc, _ := transform.NewDoc(html)
	selector := transform.NewSelectorQuery("div.comment convo clearfix", "p", "a")

	//Find all the dom nodes that match the selector above
	nodes := selector.Apply(doc)

	names := []string{}
	for i := range nodes {
		//The first child of the node will be the TextNode (the content) 
		//of the tag. This contains the name we want so append to our output array
		names = append(names, nodes[i].Children[0].String())
	}

	return names
}

//Get the names of people who created a pin
func getPinners(html string) []string {
	doc, _ := transform.NewDoc(html)
	selector := transform.NewSelectorQuery("div.convo attribution clearfix", "p")

	//Find all the dom nodes that match the selector above
	nodes := selector.Apply(doc)

	names := []string{}
	for i := range nodes {
		//The name we are looking for is in a different place for the pinner
		//than in the above function (this was found by just looking at the source generated
		//for the pinterest front page)
		names = append(names, nodes[i].Children[1].Children[0].String())
	}

	return names
}

//Load the frontpage of pinterest into a string and return it
func getFrontPage() (string, error) {
	//Make an http request for the front page of pinterest
	resp, err := http.Get("http://pinterest.com")

	if err != nil {
		fmt.Println(err)
		return "", err
	} else {
		//Defer will make sure to close the response body no matter how this function ends
		//(I'm not sure why we need to close the response, but its in the docs and
		//I guess its some kind of IOStream)
		defer resp.Body.Close()

		//read the response body into a string (actually its a []byte)
		content, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			fmt.Println(err)
			return "", err
		} else {
			//convert the content to a string from []byte and return it
			return string(content), err
		}
	}
	//So for some reason Go is not able to tell that i will not reach this line
	//so I need to return something that satisfies the signature of this function.
	return "", nil
}
