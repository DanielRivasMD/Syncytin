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

// neighborhood range
const (
	neighbor = 10000
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// declarations
var (
	fileOut  string     // infered from input
	syncytin identified // identified struct

	// command line arguments
	dataDir     string = os.Args[1]
	readFile    string = os.Args[2]
	scaffold    string = os.Args[3]
	stringStart string = os.Args[4]
	stringEnd   string = os.Args[5]
	suffix      string = os.Args[6]
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
	syncytin.scaffold = scaffold

	// positions
	syncytin.positions.parseMinMax(stringStart, stringEnd)

	// declare file output
	fileOut = defineOut(readFile, suffix)

	// execute logic
	collectCoordinates(dataDir + "/" + "DNAzoo" + "/" + readFile)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// define output file
func defineOut(readFile, suffix string) string {

	var path string
	if suffix == "" {
		path = "candidate"
	} else {
		path = "insertion"
	}

	fileOut = readFile
	reg := regexp.MustCompile(`HiC*`)
	res := reg.FindStringIndex(fileOut)
	fileOut = fileOut[0:res[0]]

	fileOut = dataDir + "/" + path + "/" +
		fileOut +
		syncytin.scaffold + "_" +
		strconv.FormatFloat(syncytin.positions.start, 'f', 0, 64) + "_" +
		strconv.FormatFloat(syncytin.positions.end, 'f', 0, 64) +
		suffix + ".fasta"
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
func collectCoordinates(readFile string) {

	contentFile, err := ioutil.ReadFile(readFile) // the file is inside the local directory
	if err != nil {
		log.Fatal("Error opending input file :", err)
	}

	// check whether file exists to avoid appending
	if fileExist(fileOut) {
		os.Remove(fileOut)
	}

	// mount data string
	dataFasta := strings.NewReader(string(contentFile))

	// fasta.Reader requires a known type template to fill
	// with FASTA data. Here we use *linear.Seq.
	template := linear.NewSeq("", nil, alphabet.DNAredundant)
	readerFasta := fasta.NewReader(dataFasta, template)

	// Make a seqio.Scanner to simplify iterating over a
	// stream of data.
	scanFasta := seqio.NewScanner(readerFasta)

	// Iterate through each sequence in a multifasta and examine the
	// ID, description and sequence data.
	for scanFasta.Next() {
		// Get the current sequence and type assert to *linear.Seq.
		// While this is unnecessary here, it can be useful to have
		// the concrete type.
		sequence := scanFasta.Seq().(*linear.Seq)

		// find scaffold
		if sequence.ID == syncytin.scaffold {

			// cast coordinates
			start := int(syncytin.positions.start)
			end := int(syncytin.positions.end)

			// extract neighborhood
			switch suffix {
			case "_upstream":
				end = start
				start = start - neighbor
			case "_downstream":
				start = end
				end = end + neighbor
			}

			id := syncytin.scaffold + "_" + strconv.FormatFloat(syncytin.positions.start, 'f', 0, 64) + "_" + strconv.FormatFloat(syncytin.positions.end, 'f', 0, 64)
			// find coordinates
			targatSeq := linear.NewSeq(id, sequence.Seq[start:end], alphabet.DNA)

			// write candidate
			writeFasta(fileOut, targatSeq)
		}

	}

	if err := scanFasta.Error(); err != nil {
		log.Fatal(err)
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// write positions
func writeFasta(fileOut string, sequence *linear.Seq) {

	// declare io
	f, err := os.OpenFile(fileOut, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		panic(err)
	}

	defer f.Close()

	// declare writer
	w := fasta.NewWriter(f, 10000)

	// writing
	_, err = w.Write(sequence)

	if err != nil {
		panic(err)
	}
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
