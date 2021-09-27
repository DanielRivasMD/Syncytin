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

var (
	readFile string = os.Args[1] // command line argument
	// fileOut  string
)

////////////////////////////////////////////////////////////////////////////////////////////////////

// command line
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
	start int
	end   int
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

	// fileOut := readFile

	annotate(readFile)
}

////////////////////////////////////////////////////////////////////////////////////////////////////

func annotate(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opending input file :", readErr)
	}

	// // check whether file exists to avoid appending
	// if fileExist(fileOut) {
	// 	os.Remove(fileOut)
	// }

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

func annotationCollect(records []string, ct int) int {

	if len(records) > 1 {

		// declare annotation struct
		var annotations annotation

		// scaffold
		annotations.scaffold = records[0]

		// class / type
		annotations.class = records[2]

		// positions
		tmpStart, _ := strconv.ParseFloat(records[3], 64)
		tmpEnd, _ := strconv.ParseFloat(records[4], 64)

		annotations.positions.start = int(math.Min(tmpStart, tmpEnd))
		annotations.positions.end = int(math.Max(tmpStart, tmpEnd))

		// score
		annotations.score, _ = strconv.ParseInt(records[5], 10, 64)

		// strand
		annotations.strand = records[6]

		// raw attributes
		rawAttributes := records[8]

		// TODO: test on scaffold 3
		annotStart := 21359746.
		annotEnd := 21358328.
		fixedStart := int(math.Min(annotStart, annotEnd))
		fixedEnd := int(math.Max(annotStart, annotEnd))
		nuclWindow := 100000

		if /*len(records) == 9 && */ annotations.scaffold == "HiC_scaffold_3" && annotations.positions.start > (fixedStart-nuclWindow) && annotations.positions.end < (fixedEnd+nuclWindow) && annotations.class == "gene" {
			// counter
			ct++

			// segregate attributes
			attributeSegregate(rawAttributes, &annotations.attributes)

			// printing
			fmt.Println("")
			fmt.Println("Scaffold: ", annotations.scaffold)
			fmt.Println("Syncytin positions: ", fixedStart, " - ", fixedEnd)
			fmt.Println("Positions: ", annotations.positions.start, " - ", annotations.positions.end)
			fmt.Println("Class / Type: ", annotations.class)
			fmt.Println("Score: ", annotations.score)
			fmt.Println("Strand: ", annotations.strand)

			fmt.Println("Attributes")
			fmt.Println("\tID: ", annotations.attributes.ID)
			fmt.Println("\tName: ", annotations.attributes.Name)
			fmt.Println("\tAlias: ", annotations.attributes.Alias)
			fmt.Println("\tParent: ", annotations.attributes.Parent)
			fmt.Println("\tTarget: ", annotations.attributes.Target)
			fmt.Println("\tNote: ", annotations.attributes.Note)
		}
	} else if records[0] != "###" {
		fmt.Println("Records: ", records)
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

func (attributes *attribute) AddAttribute(ats, field string) {
	if strings.Contains(ats, field) {
		out := strings.TrimPrefix(ats, field+"=")
		final := reflect.ValueOf(attributes).Elem()
		final.FieldByName(field).Set(reflect.ValueOf(out))
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
