package main

import (
	"io/ioutil"
	"log"
	"os"
)

func main() {

	// get file list
	files, err := ioutil.ReadDir(directory)
	if err != nil {
		log.Fatal(err)
	}

	////////////////////////////////////////////////////
	// declare values
	//
	//modify according to extraction patterns
	fields := []string{
		"Assembly",
		"Level",
		"Organism",
		"ScaffoldCount",
		"ScaffoldN50",
		"ContigCount",
		"ContigN50",
		"TotalLength",
	}
	//
	// loop through array to keep values ordered
	initRecord := make(map[string]string)
	////////////////////////////////////////////////////
	
	// print head
	currentRecord := csvPrinter(true, fields, initRecord)

	for _, f := range files {

		filefull := directory + f.Name()
		// open an input file, exit on error
		inputFile, readErr := os.Open(filefull)
		if readErr != nil {
			log.Fatal("Error opening input file : ", readErr)
		}

		// extract data
		updatedRecord := fieldExtractor(inputFile, currentRecord)

		// print lines
		csvPrinter(false, fields, updatedRecord)

		// close file
		closeErr := inputFile.Close()
		if closeErr != nil {
			log.Fatal("Error closing input file : ", closeErr)
		}
	}
}