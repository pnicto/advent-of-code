package main

import (
	"fmt"
	"log"
	"math"
	"strconv"
	"strings"

	"github.com/pnicto/aoc/utils"
	"golang.org/x/exp/slices"
)

type Card struct {
	winningNumbers []int
	nums           []int
}

func cardify(card string) Card {
	var c Card
	strippedCard := strings.Fields(card)[2:]

	splits := strings.Split(strings.Join(strippedCard, " "), " | ")

	for _, winningNumber := range strings.Split(splits[0], " ") {
		wn, err := strconv.Atoi(string(winningNumber))
		if err != nil {
			log.Fatalln(err, winningNumber)
		}
		c.winningNumbers = append(c.winningNumbers, wn)
	}

	for _, num := range strings.Split(splits[1], " ") {
		n, err := strconv.Atoi(string(num))
		if err != nil {
			log.Fatalln(err, num)
		}
		c.nums = append(c.nums, n)
	}

	return c
}

func getMatches(card Card) []int {
	var matches []int
	for _, winningNumber := range card.winningNumbers {
		if slices.Contains(card.nums, winningNumber) {
			matches = append(matches, winningNumber)
		}
	}
	return matches
}

func part1(contents string) float64 {
	var sum float64
	cards := strings.Split(contents, "\n")
	for _, card := range cards {
		c := cardify(card)
		matches := getMatches(c)
		if len(matches) > 0 {
			sum += math.Pow(2, float64(len(matches)-1))
		}
	}
	return sum
}

func part2(contents string) int {
	sum := 0
	cards := strings.Split(contents, "\n")
	copiesCount := make([]int, len(cards))
	for i := range copiesCount {
		copiesCount[i] = 1
	}

	for cno, card := range cards {
		c := cardify(card)
		matches := getMatches(c)

		for j := copiesCount[cno]; j > 0; j-- {
			for i := cno + 1; i <= cno+len(matches); i++ {
				copiesCount[i]++
			}
		}
	}

	for _, instance := range copiesCount {
		sum += instance
	}

	return sum
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
	fmt.Println(part2(contents))
}
