package main

import (
	"fmt"
	"sort"
	"strings"

	"github.com/pnicto/aoc/utils"
)

type Hand struct {
	cards      map[string]int
	cardString string
	bid        int
	kind       int
}

func getCards(cards string) map[string]int {
	dict := make(map[string]int)
	for _, card := range cards {
		dict[string(card)] += 1
	}
	return dict
}

func isFourOfAKind(h Hand) bool {
	for _, v := range h.cards {
		if v == 4 {
			return true
		}
	}
	return false
}

func isThreeOfAKind(h Hand) bool {
	for _, v := range h.cards {
		if v == 3 {
			return true
		}
	}
	return false
}

func getKind(h Hand) int {
	kind := 0
	length := len(h.cards)
	switch length {
	case 1:
		kind = 7
	case 2:
		if isFourOfAKind(h) {
			kind = 6
		} else {
			// full house
			kind = 5
		}
	case 3:
		if isThreeOfAKind(h) {
			kind = 4
		} else {
			// two pair
			kind = 3
		}
	case 4:
		// one pair
		kind = 2
	case 5:
		// high card
		kind = 1
	}
	return kind
}

func getKindWithJoker(h Hand) int {
	maxFreq := 0
	maxFreqCard := ""

	for c, freq := range h.cards {
		if c != "J" {
			if freq > maxFreq {
				maxFreq = freq
				maxFreqCard = c
			}
		}
	}

	newCards := make(map[string]int)
	if jFreq, ok := h.cards["J"]; ok {
		newCards[maxFreqCard] = maxFreq + jFreq
	} else {
		newCards[maxFreqCard] = maxFreq
	}
	for k, v := range h.cards {
		if k != "J" && k != maxFreqCard {
			newCards[k] = v
		}
	}
	h.cards = newCards

	return getKind(h)
}

func createHand(handString string) Hand {
	var h Hand
	splits := strings.Split(handString, " ")
	h.cardString = splits[0]
	h.cards = getCards(h.cardString)
	h.bid = utils.ToInt(splits[1])
	// part 1
	// h.kind = getKind(h)
	h.kind = getKindWithJoker(h)

	return h
}

func isHandPowerful(h1 string, h2 string) bool {
	cardLookup := map[string]int{
		"A": 14,
		"K": 13,
		"Q": 12,
		// part 1
		// "J": 11,
		"T": 10,
		"9": 9,
		"8": 8,
		"7": 7,
		"6": 6,
		"5": 5,
		"4": 4,
		"3": 3,
		"2": 2,
		"J": 1,
	}
	for i := range h1 {
		if h1[i] == h2[i] {
			continue
		} else if cardLookup[string(h1[i])] > cardLookup[string(h2[i])] {
			return true
		} else {
			return false
		}
	}
	return false
}

func part1(contents string) int {
	var totalWinnings int
	var hands []Hand

	handStrings := strings.Split(contents, "\n")
	for _, handString := range handStrings {
		hand := createHand(handString)
		hands = append(hands, hand)
	}

	sort.Slice(hands, func(i, j int) bool {
		if hands[i].kind > hands[j].kind {
			return false
		} else if hands[i].kind == hands[j].kind {
			return !isHandPowerful(hands[i].cardString, hands[j].cardString)
		} else {
			return true
		}
	})

	for i, hand := range hands {
		totalWinnings += hand.bid * (i + 1)
	}

	return totalWinnings
}

func part2(contents string) int {
	var totalWinnings int
	var hands []Hand

	handStrings := strings.Split(contents, "\n")
	for _, handString := range handStrings {
		hand := createHand(handString)
		hands = append(hands, hand)
	}

	sort.Slice(hands, func(i, j int) bool {
		if hands[i].kind > hands[j].kind {
			return false
		} else if hands[i].kind == hands[j].kind {
			return !isHandPowerful(hands[i].cardString, hands[j].cardString)
		} else {
			return true
		}
	})

	for i, hand := range hands {
		totalWinnings += hand.bid * (i + 1)
	}

	return totalWinnings
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part2(contents))
}
