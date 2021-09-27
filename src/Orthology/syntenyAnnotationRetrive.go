////////////////////////////////////////////////////////////////////////////////////////////////////

package main

////////////////////////////////////////////////////////////////////////////////////////////////////

import (
	"bufio"
	"fmt"
	"log"
	"math"
	"os"
	"reflect"
	"strconv"
	"strings"
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// synteny range
const (
	nuclWindow = 500000.
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// declarations
var (
	fileOut  string     // infered from input
	syncytin identified // identified struct

	// command line arguments
	readFile      string = os.Args[1]
	annotScaffold string = os.Args[2]
	stringStart   string = os.Args[3]
	stringEnd     string = os.Args[4]
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// syncytin features
type identified struct {
	scaffold  string
	positions position
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// annotations
type annotation struct {
	scaffold   string
	class      string
	positions  position
	score      int64
	strand     string
	attributes attribute
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// positions
type position struct {
	start float64
	end   float64
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// attributes
type attribute struct {
	ID     string
	Name   string
	Alias  string
	Parent string
	Target string
	Note   string
}

////////////////////////////////////////////////////////////////////////////////////////////////////

func main() {

	// declare file output
	fileOut = readFile
	fileOut = strings.TrimSuffix(fileOut, ".gff3")
	fileOut = fileOut + ".txt"

	// scaffold
	syncytin.scaffold = annotScaffold

	// positions
	syncytin.positions.parseMinMax(stringStart, stringEnd)

	// execute logic
	annotate(readFile)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// print annotations
func (annotations *annotation) print() string {
	return annotations.scaffold + "," +
		strconv.FormatFloat(annotations.positions.start, 'f', 0, 64) + "," +
		strconv.FormatFloat(annotations.positions.end, 'f', 0, 64) + "," +
		annotations.class + "," + strconv.FormatInt(annotations.score, 10) + "," +
		annotations.strand + "," +
		annotations.attributes.ID + "," +
		annotations.attributes.Alias + "," +
		annotations.attributes.Note + "\n"

}

////////////////////////////////////////////////////////////////////////////////////////////////////

// pass struct as reference to update
func min_max(position *position, num1, num2 float64) {
	position.start = math.Min(num1, num2)
	position.end = math.Max(num1, num2)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// parse values & determine minimum / maximum
func (position *position) parseMinMax(str1, str2 string) {
	num1, _ := strconv.ParseFloat(str1, 64)
	num2, _ := strconv.ParseFloat(str2, 64)

	min_max(position, num1, num2)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// read file & collect annotations
func annotate(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opending input file :", readErr)
	}

	// check whether file exists to avoid appending
	if fileExist(fileOut) {
		os.Remove(fileOut)
	}

	ct := 0
	// scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(inputFile)

	for scanner.Scan() {

		// split line records by tab
		records := strings.Split(scanner.Text(), "\t")

		// collect patterns. internal values are redeclared every iteration
		ct = annotationCollect(records, ct)

	}

	fmt.Println("Number of hits: ", ct)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// annotations := []string{
// 	"seqid",
// 	"source",
// 	"type",
// 	"start",
// 	"end",
// 	"score",
// 	"strand",
// 	"phase",
// 	"attributes",
// }

////////////////////////////////////////////////////////////////////////////////////////////////////

// collect annotations
func annotationCollect(records []string, ct int) int {

	if len(records) > 1 {

		// declare annotation struct
		var annotations annotation

		// scaffold
		annotations.scaffold = records[0]

		// class / type
		annotations.class = records[2]

		// positions
		annotations.positions.parseMinMax(records[3], records[4])

		// score
		annotations.score, _ = strconv.ParseInt(records[5], 10, 64)

		// strand
		annotations.strand = records[6]

		// raw attributes
		rawAttributes := records[8]

		if annotations.scaffold == syncytin.scaffold &&
			annotations.positions.start > (syncytin.positions.start-nuclWindow) &&
			annotations.positions.end < (syncytin.positions.end+nuclWindow) &&
			annotations.class == "gene" {
			// counter
			ct++

			// segregate attributes
			attributeSegregate(rawAttributes, &annotations.attributes)

			// write
			writeSyntenyGenes(fileOut, annotations)
		}
	}
	return ct
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// attributes := []strings{
// 	"ID",
// 	"Name",
// 	"Alias",
// 	"Parent",
// 	"Target",
// 	"Gap",
// 	"Derives_from",
// 	"Note",
// 	"Dbxref",
// 	"Ontology_term",
// 	"Is_circular",
// }

////////////////////////////////////////////////////////////////////////////////////////////////////

// pass struct as reference to update
func attributeSegregate(rawAttributes string, attributes *attribute) {

	// collect attribute struct field names
	fields := reflect.TypeOf(*attributes)

	// collect attributes
	arrayAttributes := strings.Split(rawAttributes, ";")

	// loop over attribute string array
	for ix := 0; ix < len(arrayAttributes); ix++ {

		num := fields.NumField()
		// loop over attribute struct fields
		for i := 0; i < num; i++ {
			field := fields.Field(i)
			attributes.AddAttribute(arrayAttributes[ix], field.Name)
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// add collected attribute
func (attributes *attribute) AddAttribute(ats, field string) {
	if strings.Contains(ats, field) {
		out := strings.TrimPrefix(ats, field+"=")
		final := reflect.ValueOf(attributes).Elem()
		final.FieldByName(field).Set(reflect.ValueOf(out))
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////

// write positions
func writeSyntenyGenes(fileOut string, annotations annotation) {

	f, err := os.OpenFile(fileOut, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		panic(err)
	}

	defer f.Close()

	w := bufio.NewWriter(f)

	// printing
	_, err = w.WriteString(annotations.print())

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
