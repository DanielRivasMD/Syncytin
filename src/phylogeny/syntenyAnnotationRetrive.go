package main

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

var (
	readFile string = os.Args[1]
	// fileOut  string
)

type annotStruct struct {
	scaffold string
	class    string
	position positionStruct
	score    int64
	strand   string
	annots   attributesStruct
}

type positionStruct struct {
	start int
	end   int
}

type attributesStruct struct {
	ID     string
	Name   string
	Alias  string
	Parent string
	Target string
	Note   string
}

func main() {

	// fileOut := readFile

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

func collectAnnotations(records []string, ct int) int {

	if len(records) > 1 {

		// declare annotation struct
		var annots annotStruct

		// scaffold
		annots.scaffold = records[0]

		// class / type
		annots.class = records[2]

		// positions
		tmpStart, _ := strconv.ParseFloat(records[3], 64)
		tmpEnd, _ := strconv.ParseFloat(records[4], 64)

		annots.position.start = int(math.Min(tmpStart, tmpEnd))
		annots.position.end = int(math.Max(tmpStart, tmpEnd))

		// score
		annots.score, _ = strconv.ParseInt(records[5], 10, 64)

		// strand
		annots.strand = records[6]

		// raw attributes
		attrs := records[8]

		// TODO: test on scaffold 3
		annotStart := 21359746.
		annotEnd := 21358328.
		fixedStart := int(math.Min(annotStart, annotEnd))
		fixedEnd := int(math.Max(annotStart, annotEnd))
		nuclWindow := 100000

		if /*len(records) == 9 && */ annots.scaffold == "HiC_scaffold_3" && annots.position.start > (fixedStart-nuclWindow) && annots.position.end < (fixedEnd+nuclWindow) && annots.class == "gene" {
			// counter
			ct++

			// segregate attributes
			segregateAttributes(attrs, &annots)

			// printing
			fmt.Println("")
			fmt.Println("Scaffold: ", annots.scaffold)
			fmt.Println("Syncytin positions: ", fixedStart, " - ", fixedEnd)
			fmt.Println("Positions: ", annots.position.start, " - ", annots.position.end)
			fmt.Println("Class / Type: ", annots.class)
			fmt.Println("Score: ", annots.score)
			fmt.Println("Strand: ", annots.strand)

			fmt.Println("Attributes")
			fmt.Println("\tID: ", annots.annots.ID)
			fmt.Println("\tName: ", annots.annots.Name)
			fmt.Println("\tAlias: ", annots.annots.Alias)
			fmt.Println("\tParent: ", annots.annots.Parent)
			fmt.Println("\tTarget: ", annots.annots.Target)
			fmt.Println("\tNote: ", annots.annots.Note)
			// fmt.Println("Annotations: ", attrs)
			// fmt.Println("Other data: ", records)
			// fmt.Println("")
		}
	} else if records[0] != "###" {
		fmt.Println("Records: ", records)
	}
	return ct
}

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

// pass struct as reference to update
func segregateAttributes(attrs string, annots *annotStruct) {

	// collect attribute struct field names
	fields := reflect.TypeOf(annots.annots)

	// collect attributes
	attr := strings.Split(attrs, ";")

	// loop over attribute string array
	for ix := 0; ix < len(attr); ix++ {

		// loop over attribute struct fields
		for i := 0; i < fields.NumField(); i++ {
			field := fields.Field(i)
			annots.annots.AddAttribute(attr[ix], field.Name)
		}
	}
}

func (att *attributesStruct) AddAttribute(ats, field string) {
	if strings.Contains(ats, field) {
		out := strings.TrimPrefix(ats, field+"=")
		final := reflect.ValueOf(att).Elem()
		final.FieldByName(field).Set(reflect.ValueOf(out))
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
