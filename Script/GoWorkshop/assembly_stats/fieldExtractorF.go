package main

import (
	"bufio"
	"os"
	"strings"
)

func fieldExtractor(scanFile *os.File, toPrintRecord map[string]string) map[string]string {

	//scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(scanFile)

	for scanner.Scan() {

		records := strings.Split(scanner.Text(), "\t")

		// TODO: use switch instead of if
		// Assembly name
		if strings.Contains(records[0], "Assembly name") {
			toPrintRecord["Assembly"] = spaceTrimmer(splitColon(records[0]))
		}

		// Assembly level
		if strings.Contains(records[0], "Assembly level") {
			toPrintRecord["Level"] = spaceTrimmer(splitColon(records[0]))
		}

		// Organism name
		if strings.Contains(records[0], "Organism name") {
			toPrintRecord["Organism"] = spaceTrimmer(splitColon(records[0]))
		}

		// total-length
		if len(records) >= 5 && records[0] == "all" && records[4] == "total-length" {
			toPrintRecord["TotalLength"] = records[5]
		}

		// scaffold-N50
		if len(records) >= 5 && records[0] == "all" && records[4] == "scaffold-N50" {
			toPrintRecord["ScaffoldN50"] = records[5]
		}

		// scaffold-count
		if len(records) >= 5 && records[0] == "all" && records[4] == "scaffold-count" {
			toPrintRecord["ScaffoldCount"] = records[5]
		}

		// contig-N50
		if len(records) >= 5 && records[0] == "all" && records[4] == "contig-N50" {
			toPrintRecord["ContigN50"] = records[5]
		}

		// contig-count
		if len(records) >= 5 && records[0] == "all" && records[4] == "contig-count" {
			toPrintRecord["ContigCount"] = records[5]
		}
	}
	return toPrintRecord
}
