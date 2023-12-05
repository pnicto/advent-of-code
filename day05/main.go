package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	"github.com/pnicto/aoc/utils"
)

func toInt(s string) int {
	num, err := strconv.Atoi(s)
	if err != nil {
		log.Fatalln(err, s)
	}
	return num
}

func getSeeds(seedLine string) []int {
	var seeds []int
	seedStrings := strings.Fields(seedLine)[1:]
	for _, seedString := range seedStrings {
		seeds = append(seeds, toInt(seedString))
	}

	return seeds
}

func mappify(input string) map[int]int {
	lookup := make(map[int]int)
	inputRanges := strings.Split(input, "\n")[1:]

	for _, rangeString := range inputRanges {
		splits := strings.Split(rangeString, " ")
		dest := toInt(splits[0])
		source := toInt(splits[1])
		offset := toInt(splits[2])
		for i := offset - 1; i >= 0; i-- {
			lookup[source+i] = dest + i
		}
	}
	return lookup
}

func part1(contents string) int {
	leastLocation := -1
	var lookups []map[int]int

	splits := strings.Split(contents, "\n\n")
	seeds := getSeeds(splits[0])

	for _, split := range splits[1:] {
		lookups = append(lookups, mappify(split))
	}

	for _, seed := range seeds {
		prevLookup := seed
		for _, lookup := range lookups {
			val, ok := lookup[prevLookup]
			if ok {
				prevLookup = val
			}
		}
		if leastLocation == -1 || prevLookup < leastLocation {
			leastLocation = prevLookup
		}
	}

	return leastLocation
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
}
