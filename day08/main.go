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

// Brute force works for part 2, but is too slow
func traversePathGhost(instruction string, lookup map[string]Node, startNodes []string) int {
	const END = "Z"
	current := startNodes

	i := 0

	for {
		var newCurrent []string
		for _, node := range current {
			choice := string(instruction[i%len(instruction)])

			if choice == "L" {
				newCurrent = append(newCurrent, lookup[node].left)
			} else {
				newCurrent = append(newCurrent, lookup[node].right)
			}
		}
		current = newCurrent

		count := 0
		for _, node := range newCurrent {
			if strings.HasSuffix(node, END) {
				count++
			}
		}

		if count == len(startNodes) {
			break
		}
		i++
	}

	return i + 1
}

func traversePathTest(instruction string, lookup map[string]Node, startNode string) int {
	const END = "Z"
	current := startNode
	i := 0

	for !strings.HasSuffix(current, END) {
		choice := string(instruction[i%len(instruction)])

		if choice == "L" {
			current = lookup[current].left
		} else {
			current = lookup[current].right
		}
		i++
	}
	fmt.Println(current)
	return i
}

func gcd(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

func part2(contents string) int {
	lookup := make(map[string]Node)

	splits := strings.Split(contents, "\n\n")
	instructions := splits[0]

	splits = strings.Split(splits[1], "\n")

	startNodes := []string{}

	for _, split := range splits {
		value, left, right := parseNode(split)
		if strings.HasSuffix(value, "A") {
			startNodes = append(startNodes, value)
		}
		lookup[value] = Node{left, right}
	}

	var nums []int

	for _, startNode := range startNodes {
		temp := traversePathTest(instructions, lookup, startNode)
		nums = append(nums, temp)
	}

	fmt.Println(nums)

	return 0
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part2(contents))
}
