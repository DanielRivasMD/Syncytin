////////////////////////////////////////////////////////////////////////////////////////////////////

package main

////////////////////////////////////////////////////////////////////////////////////////////////////

import (
	"io/ioutil"
	"log"
	"math"
	"os"
	"regexp"
	"strconv"
	"strings"

	"github.com/biogo/biogo/alphabet"
	"github.com/biogo/biogo/io/seqio"
	"github.com/biogo/biogo/io/seqio/fasta"
	"github.com/biogo/biogo/seq/linear"
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// declarations
var (
	fileOut  string     // infered from input
	syncytin identified // identified struct

	// command line arguments
	dataDir       string = os.Args[1]
	readFile      string = os.Args[2]
	annotScaffold string = os.Args[3]
	stringStart   string = os.Args[4]
	stringEnd     string = os.Args[5]
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// syncytin features
type identified struct {
	scaffold  string
	positions position
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// positions
type position struct {
	start float64
	end   float64
}

////////////////////////////////////////////////////////////////////////////////////////////////////

func main() {

	// scaffold
	syncytin.scaffold = annotScaffold

	// positions
	syncytin.positions.parseMinMax(stringStart, stringEnd)

	// declare file output
	fileOut = defineOut(readFile)

	// execute logic
	collect(dataDir + "/" + "DNAzoo" + "/" + readFile)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// define output file
func defineOut(readFile string) string {
	fileOut = readFile
	reg := regexp.MustCompile(`HiC*`)
	res := reg.FindStringIndex(fileOut)
	fileOut = fileOut[0:res[0]]
	fileOut = dataDir + "/" + "candidate" + "/" +
		fileOut +
		syncytin.scaffold + "_" +
		strconv.FormatFloat(syncytin.positions.start, 'f', 0, 64) + "_" +
		strconv.FormatFloat(syncytin.positions.end, 'f', 0, 64) + ".fasta"
	return fileOut
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// pass struct as reference to update
func (position *position) minMax(num1, num2 float64) {
	position.start = math.Min(num1, num2)
	position.end = math.Max(num1, num2)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// parse values & determine minimum / maximum
func (position *position) parseMinMax(str1, str2 string) {
	num1, _ := strconv.ParseFloat(str1, 64)
	num2, _ := strconv.ParseFloat(str2, 64)

	position.minMax(num1, num2)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// read file & collect sequences
func collect(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opending input file :", readErr)
	}

	// check whether file exists to avoid appending
	if fileExist(fileOut) {
		os.Remove(fileOut)
	}

	// scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(inputFile)

	for scanner.Scan() {

		// split line records by tab
		records := strings.Split(scanner.Text(), "\t")

		// collect sequences
		candidateCollect(records)

	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// collect sequences
func candidateCollect(records []string) {

	// find scaffold

	// concatenate sequence

	// collect sequence by coordinates

}

////////////////////////////////////////////////////////////////////////////////////////////////////

// write positions
func writeSyntenyGenes(fileOut string, sequence sequence) {

	f, err := os.OpenFile(fileOut, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		panic(err)
	}

	defer f.Close()

	w := bufio.NewWriter(f)

	// printing
	_, err = w.WriteString(sequence.print())

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
