package utils

import (
	"io"
	"log"
	"os"
	"strconv"
	"strings"
)

func ReadInput(filename string) string {
	f, err := os.Open(filename)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	b, err := io.ReadAll(f)
	if err != nil {
		log.Fatalln(err)
	}

	contents := string(b)
	contents = strings.TrimSpace(contents)
	return contents
}

func ToInt(s string) int {
	num, err := strconv.Atoi(s)
	if err != nil {
		log.Fatalln(err, s)
	}
	return num
}
