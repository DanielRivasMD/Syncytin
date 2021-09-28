////////////////////////////////////////////////////////////////////////////////////////////////////

package main

////////////////////////////////////////////////////////////////////////////////////////////////////

import (
	"bufio"
	"log"
	"os"
	"strconv"
	"strings"
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// declarations
var (
	fileOut string // infered from input

	// command line arguments
	readFile string = os.Args[1]
)

////////////////////////////////////////////////////////////////////////////////////////////////////

func main() {

	// declare file output
	fileOut = defineOut(readFile)

	// execute logic
	genomicPositionsCollect(readFile)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// define output file
func defineOut(readFile string) string {
	fileOut = readFile
	fileOut = strings.TrimSuffix(fileOut, ".tsv")
	fileOut = fileOut + "_filtered.tsv"
	return fileOut
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// read file, filter records & write
func genomicPositionsCollect(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opening input file : ", readErr)
	}

	// check whether file exists to avoid appending
	if fileExist(fileOut) {
		os.Remove(fileOut)
	}

	// headers := []string{
	// 	"qseqid",
	// 	"sseqid",
	// 	"pident",
	// 	"length",
	// 	"mismatch",
	// 	"gapopen",
	// 	"qstart",
	// 	"qend",
	// 	"sstart",
	// 	"send",
	// 	"evalue",
	// 	"bitscore",
	// }

	// scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(inputFile)

	for scanner.Scan() {

		// tab separated records
		records := strings.Split(scanner.Text(), "\t")

		// collect patterns
		pIdent, _ := strconv.ParseFloat(records[2], 64)
		alignLen, _ := strconv.ParseFloat(records[3], 64)

		// filter criteria
		if pIdent > 70 && alignLen > 350 {
			// write
			writeGenomicPositions(fileOut, records)
		}

	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// write positions
func writeGenomicPositions(fileOut string, records []string) {

	f, err := os.OpenFile(fileOut, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		panic(err)
	}

	defer f.Close()

	w := bufio.NewWriter(f)
	_, err = w.WriteString(records[0] + " " + records[1] + " " + records[2] + " " + records[6] + " " + records[7] + " " + records[10] + "\n")
	if err != nil {
		panic(err)
	}

	w.Flush()
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// fileExist checks if a file exists and is not a directory before
// try using it to prevent further errors
func fileExist(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}

////////////////////////////////////////////////////////////////////////////////////////////////////
