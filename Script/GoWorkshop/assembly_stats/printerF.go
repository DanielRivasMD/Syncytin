package main

import "fmt"

func csvPrinter(head bool, internalFields[]string, internalRecord map[string]string) map[string]string {

	printVal := ""
	for ix, fi := range internalFields {
		if head {
			printVal = fi
		} else {
			printVal = internalRecord[fi]
		}

		if ix == len(internalFields) - 1 {

			// last value gets a new line
			fmt.Println(printVal)
		} else {

			// format for comma separated file
			fmt.Print(printVal, ",")
		}

		// empty map
		internalRecord[fi] = ""
	}
	return internalRecord
}
