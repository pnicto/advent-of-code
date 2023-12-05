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

type Map struct {
	destination int
	source      int
	offset      int
}

func mappify(input string) []Map {
	var maps []Map
	inputRanges := strings.Split(input, "\n")[1:]

	for _, rangeString := range inputRanges {
		splits := strings.Split(rangeString, " ")
		dest := toInt(splits[0])
		source := toInt(splits[1])
		offset := toInt(splits[2])
		maps = append(maps, Map{dest, source, offset})
	}
	return maps
}

func lookup(target int, table []Map) int {
	for _, m := range table {
		if target >= m.source && target < m.source+m.offset {
			return m.destination + (target - m.source)
		}
	}
	return target
}

func part1(contents string) int {
	leastLocation := -1
	var lookups [][]Map

	splits := strings.Split(contents, "\n\n")
	seeds := getSeeds(splits[0])

	for _, split := range splits[1:] {
		lookups = append(lookups, mappify(split))
	}

	for _, seed := range seeds {
		prevLookup := seed

		for _, l := range lookups {
			prevLookup = lookup(prevLookup, l)
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
