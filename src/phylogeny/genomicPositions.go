package main

import (
	"bufio"
	"log"
	"os"
	"strconv"
	"strings"
)

var (
	readFile string = os.Args[1]
	fileOut  string
)

func main() {
	fileOut = readFile
	fileOut = strings.TrimSuffix(fileOut, ".tsv")
	fileOut = fileOut + "_filtered.tsv"

	genomicPositionsCollect(readFile)
}

func genomicPositionsCollect(readFile string) {

	// open an input file, exit on error
	inputFile, readErr := os.Open(readFile)
	if readErr != nil {
		log.Fatal("Error opening input file : ", readErr)
	}

	//headers := []string{
	//"qseqid",
	//"sseqid",
	//"pident",
	//"length",
	//"mismatch",
	//"gapopen",
	//"qstart",
	//"qend",
	//"sstart",
	//"send",
	//"evalue",
	//"bitscore",
	//}

	// scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(inputFile)

	for scanner.Scan() {

		records := strings.Split(scanner.Text(), "\t")

		// collect pattern
		pIdent, _ := strconv.ParseFloat(records[2], 64)
		alignLen, _ := strconv.ParseFloat(records[3], 64)

		if pIdent > 80 && alignLen > 400 {
			writeGenomicPositions(fileOut, records)
		}

	}
}

func writeGenomicPositions(fileOut string, records []string) {

	// write
	f, err := os.OpenFile(fileOut, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0666)

	if err != nil {
		panic(err)
	}

	defer f.Close()

	w := bufio.NewWriter(f)
	_, err = w.WriteString(records[0] + " " + records[1] + " " + records[6] + " " + records[7] + "\n")
	if err != nil {
		panic(err)
	}

	w.Flush()
}
