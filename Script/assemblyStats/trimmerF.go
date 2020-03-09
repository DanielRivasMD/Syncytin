package main

import "strings"

func spaceTrimmer(field string) string {
	return strings.TrimLeft(field, " ")
}

func splitColon(toSplit string) string {
	return strings.Split(toSplit, ":")[1]
}
