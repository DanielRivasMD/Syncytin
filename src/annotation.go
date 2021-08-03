package main

import (
	"bufio"
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"strings"
)

var (
	readFile string = os.Args[1]
	// fileOut  string
)

type annotStruct struct {
	scaffold string
	position positionStruct
	annots   attributesStruct
}

type positionStruct struct {
	start int
	end   int
}

type attributesStruct struct {
	id     string
	name   string
	target string
}

func main() {
	annotFunc(readFile)
}

func annotFunc(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opending input file :", readErr)
	}

	// // check whether file exists to avoid appending
	// if fileExists(fileOut) {
	// 	os.Remove(fileOut)
	// }

	ct := 0
	// scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(inputFile)

	for scanner.Scan() {

		// split line records by tab
		records := strings.Split(scanner.Text(), "\t")

		// collect patterns. internal values are redeclared every iteration
		ct = collectAnnotations(records, ct)

	}

	fmt.Println("Number of hits: ", ct)
}

func collectAnnotations(records []string, ct int) int {

	// declare struct
	var annots annotStruct

	// scaffold
	annots.scaffold = records[0]

	if len(records) >= 4 {
		// positions
		tmpStart, _ := strconv.ParseFloat(records[3], 64)
		tmpEnd, _ := strconv.ParseFloat(records[4], 64)

		annots.position.start = int(math.Min(tmpStart, tmpEnd))
		annots.position.end = int(math.Max(tmpStart, tmpEnd))
	}

	// initialize raw attribute holder
	var attrs string
	if len(records) == 9 {
		attrs = records[8]
	}

	// TODO: test on scaffold 3
	annotStart := 21359746.
	annotEnd := 21358328.
	fixedStart := int(math.Min(annotStart, annotEnd))
	fixedEnd := int(math.Max(annotStart, annotEnd))
	nuclWindow := 1000

	if len(records) == 9 && annots.scaffold == "HiC_scaffold_3" && annots.position.start > (fixedStart-nuclWindow) && annots.position.end < (fixedEnd+nuclWindow) {
		// counter
		ct++

		// segregate attributes
		segregateAttributes(attrs, &annots)

		// printing
		fmt.Println("")
		fmt.Println("Scaffold: ", annots.scaffold)
		fmt.Println("Syncytin positions: ", fixedStart, " - ", fixedEnd)
		fmt.Println("Positions: ", annots.position.start, " - ", annots.position.end)
		fmt.Println("Attributes")
		fmt.Println("\tID: ", annots.annots.id)
		fmt.Println("\tName: ", annots.annots.name)
		fmt.Println("\tTarget: ", annots.annots.target)
		fmt.Println("Annotations: ", attrs)
		fmt.Println("Other data: ", records)
		fmt.Println("")
	}
	return ct
}

// pass struct as reference to update
func segregateAttributes(attrs string, annots *annotStruct) {

	// collect attributes
	attr := strings.Split(attrs, ";")
	for ix := 0; ix < len(attr); ix++ {

		// fmt.Println("DEBUG: ", attr[ix])
		// id
		if strings.Contains(attr[ix], "ID") {
			annots.annots.id = attr[ix]
		}

		// name
		if strings.Contains(attr[ix], "Name") {
			annots.annots.name = attr[ix]
		}

		// target
		if strings.Contains(attr[ix], "Target") {
			annots.annots.target = attr[ix]
		}
	}
}

// fileExists checks if a file exists and is not a directory before
// try using it to prevent further errors
func fileExists(filename string) bool {
	info, err := os.Stat(filename)
	if os.IsNotExist(err) {
		return false
	}
	return !info.IsDir()
}
