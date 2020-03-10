package main

import (
	"bufio"
	"os"
	"strings"
)

func fieldExtractor(scanFile *os.File, internalFields[]string, toPrintRecord map[string]string) map[string]string {

	//scanner.Scan() advances to the next token returning false if an error was encountered
	scanner := bufio.NewScanner(scanFile)

	for scanner.Scan() {

		records := strings.Split(scanner.Text(), ", ")

		if itemExists(internalFields, records[0]) {

			toPrintRecord[records[0]] = records[1]
		}
	}
	return toPrintRecord
}
