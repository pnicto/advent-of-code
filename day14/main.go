package main

import (
	"fmt"
	"strings"

	"github.com/pnicto/aoc/utils"
)

func calculateLoad(lines []string) int {
	load := 0

	for i, line := range lines {
		count := 0
		for _, c := range line {
			if c == 'O' {
				count++
			}
		}
		load += count * (len(lines) - i)
	}

	return load
}

func part1(contents string) int {
	lines := strings.Split(contents, "\n")

	for i := 0; i < len(lines); i++ {
		for j := 0; j < len(lines[i]); j++ {
			k := i
			for lines[k][j] == 'O' && k-1 >= 0 && lines[k-1][j] == '.' {
				// swap them
				current := []rune(lines[k])
				prev := []rune(lines[k-1])

				current[j] = '.'
				prev[j] = 'O'

				lines[k] = string(current)
				lines[k-1] = string(prev)
				k--
			}
		}
	}

	return calculateLoad(lines)
}

func main() {
	contents := utils.ReadInput("sample.txt")
	fmt.Println(part1(contents))
	// fmt.Println(part2(contents))
}
