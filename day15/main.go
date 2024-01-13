package main

import (
	"fmt"
	"strings"

	"github.com/pnicto/aoc/utils"
)

func hash(input string) int {
	currentValue := 0

	for _, char := range input {
		currentValue += int(char)
		currentValue *= 17
		currentValue %= 256
	}

	return currentValue
}

func part1(contents string) int {
	res := 0
	inputs := strings.Split(contents, ",")

	for _, input := range inputs {
		res += hash(input)
	}

	return res
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
}
