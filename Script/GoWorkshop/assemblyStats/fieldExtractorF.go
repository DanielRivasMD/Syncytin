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

		switch {
		// Assembly name
		case strings.Contains(records[0], "Assembly name"):
			toPrintRecord["Assembly"] = spaceTrimmer(splitColon(records[0]))

		// Assembly level
		case strings.Contains(records[0], "Assembly level"):
			toPrintRecord["Level"] = spaceTrimmer(splitColon(records[0]))

		// Taxonomic ID
		case strings.Contains(records[0], "Taxid"):
			toPrintRecord["TaxonomicID"] = spaceTrimmer(splitColon(records[0]))

		// Organism name
		case strings.Contains(records[0], "Organism name"):
			toReplace := spaceTrimmer(splitColon(records[0]))
			toPrintRecord["Organism"] = strings.Replace(toReplace, ",", "", -1)

		// total-length
		case len(records) >= 5 && records[0] == "all" && records[4] == "total-length":
			toPrintRecord["TotalLength"] = records[5]

		// scaffold-N50
		case len(records) >= 5 && records[0] == "all" && records[4] == "scaffold-N50":
			toPrintRecord["ScaffoldN50"] = records[5]

		// scaffold-count
		case len(records) >= 5 && records[0] == "all" && records[4] == "scaffold-count":
			toPrintRecord["ScaffoldCount"] = records[5]

		// contig-N50
		case len(records) >= 5 && records[0] == "all" && records[4] == "contig-N50":
			toPrintRecord["ContigN50"] = records[5]

		// contig-count
		case len(records) >= 5 && records[0] == "all" && records[4] == "contig-count":
			toPrintRecord["ContigCount"] = records[5]
		}
	}
	return toPrintRecord
}
