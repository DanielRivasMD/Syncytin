package main

import (
	"bufio"
	"log"
	"os"
	"strings"
)

var readFile string = os.Args[1]

func main() {

	proteinAccessionCollect(readFile)
}

func proteinAccessionCollect(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opening input file : ", readErr)
	}

	// scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(inputFile)

	for scanner.Scan() {

		// collect pattern
		if strings.Contains(scanner.Text(), "protein_id") {

			records := strings.Split(scanner.Text(), "=")
			accession := strings.ReplaceAll(records[1], "\"", "")

			// write to stdout
			println(accession)

		}
	}
}
