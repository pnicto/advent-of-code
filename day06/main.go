package main

import (
	"fmt"
	"strings"

	"github.com/pnicto/aoc/utils"
)

func canWin(speed int, distance int, totalTime int) bool {
	totalTime -= speed
	return speed*totalTime > distance
}

func getWinningLimits(time int, distance int) []int {
	var ways []int

	low, high := 0, time
	for low <= high {
		mid := (low + high) / 2
		if canWin(mid, distance, time) {
			high = mid - 1
		} else {
			low = mid + 1
		}
	}
	ways = append(ways, low)

	low, high = 0, time
	for low <= high {
		mid := (low + high) / 2
		if canWin(mid, distance, time) {
			low = mid + 1
		} else {
			high = mid - 1
		}
	}
	ways = append(ways, low-1)

	return ways
}

func part1(contents string) int {
	splits := strings.Split(contents, "\n")
	var times []int
	var distances []int

	timeString := strings.Fields(splits[0])[1:]
	distanceString := strings.Fields(splits[1])[1:]

	for _, time := range timeString {
		times = append(times, utils.ToInt(time))
	}

	for _, distance := range distanceString {
		distances = append(distances, utils.ToInt(distance))
	}

	// array of low and high limits
	var limits [][]int

	for i := range times {
		limits = append(limits, getWinningLimits(times[i], distances[i]))
	}

	ways := 1

	for _, limit := range limits {
		lower, upper := limit[0], limit[1]
		ways *= upper - lower + 1
	}

	return ways
}

func part2(contents string) int {
	splits := strings.Split(contents, "\n")

	timeStrings := strings.Fields(splits[0])[1:]
	distanceStrings := strings.Fields(splits[1])[1:]

	timeString := strings.Join(timeStrings, "")
	distanceString := strings.Join(distanceStrings, "")

	time := utils.ToInt(timeString)
	distance := utils.ToInt(distanceString)

	// array of low and high limits
	var limits [][]int

	limits = append(limits, getWinningLimits(time, distance))

	ways := 1

	for _, limit := range limits {
		lower, upper := limit[0], limit[1]
		ways *= upper - lower + 1
	}

	return ways
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
	fmt.Println(part2(contents))
}
