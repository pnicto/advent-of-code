package main

import (
	"fmt"
	"strings"

	"github.com/pnicto/aoc/utils"
)

type Node struct {
	left  string
	right string
}

func traversePath(instruction string, lookup map[string]Node) int {
	const END = "ZZZ"
	current := "AAA"
	i := 0

	for current != END {
		choice := string(instruction[i%len(instruction)])

		if choice == "L" {
			current = lookup[current].left
		} else {
			current = lookup[current].right
		}
		i++
	}
	return i
}

func parseNode(nodeString string) (string, string, string) {
	splits := strings.Split(nodeString, " = ")
	branches := strings.Split(splits[1], ", ")
	return splits[0], branches[0][1:], branches[1][0 : len(branches[1])-1]
}

func part1(contents string) int {
	lookup := make(map[string]Node)

	splits := strings.Split(contents, "\n\n")
	instructions := splits[0]

	splits = strings.Split(splits[1], "\n")

	for _, split := range splits {
		value, left, right := parseNode(split)
		lookup[value] = Node{left, right}
	}
	return traversePath(instructions, lookup)
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
}
