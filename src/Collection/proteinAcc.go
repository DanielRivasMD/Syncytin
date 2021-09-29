////////////////////////////////////////////////////////////////////////////////////////////////////

package main

////////////////////////////////////////////////////////////////////////////////////////////////////

import (
	"bufio"
	"log"
	"os"
	"strings"
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// declarations
var (
	readFile string = os.Args[1]
	fileOut  string = os.Args[2]
)

////////////////////////////////////////////////////////////////////////////////////////////////////

func main() {

	// execute logic
	proteinAccessionCollect(readFile)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// collect accessions
func proteinAccessionCollect(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opening input file : ", readErr)
	}

	// scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(inputFile)

	// iterate
	for scanner.Scan() {

		// collect pattern
		if strings.Contains(scanner.Text(), "protein_id") {

			records := strings.Split(scanner.Text(), "=")
			accession := strings.ReplaceAll(records[1], "\"", "")

			// write
			writeProtRecord(fileOut, accession)
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// write records
func writeProtRecord(fileOut, accession string) {

	// declare io
	f, err := os.OpenFile(fileOut, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		panic(err)
	}

	defer f.Close()

	// deslcare writer
	w := bufio.NewWriter(f)

	// writing
	_, err = w.WriteString(accession + "\n")

	if err != nil {
		panic(err)
	}

	// flush writer
	w.Flush()
}

////////////////////////////////////////////////////////////////////////////////////////////////////
