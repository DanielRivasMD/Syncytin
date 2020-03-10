package main

func itemExists(internalFields[]string, item interface{}) bool {

	for _, fi := range internalFields {
		if fi == item {
			return true
		}
	}
	return false
}
