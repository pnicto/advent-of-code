package main

import (
	"fmt"
	"strings"

	"github.com/pnicto/aoc/utils"
)

func findGalaxies(lines []string) [][]int {
	var galaxies [][]int
	for x, line := range lines {
		for y, char := range line {
			if char == '#' {
				galaxies = append(galaxies, []int{x, y})
			}
		}
	}

	return galaxies
}

func findEmptyRows(lines []string) []int {
	var emptyRows []int

	for x, line := range lines {
		isEmptyRow := true
		for _, char := range line {
			if char == '#' {
				isEmptyRow = false
				break
			}
		}
		if isEmptyRow {
			emptyRows = append(emptyRows, x)
		}
	}

	return emptyRows
}

func findEmptyColumns(lines []string) []int {
	var emptyColumns []int

	for y := range lines[0] {
		isEmptyColumn := true
		for x := range lines {
			if lines[x][y] == '#' {
				isEmptyColumn = false
				break
			}
		}
		if isEmptyColumn {
			emptyColumns = append(emptyColumns, y)
		}
	}

	return emptyColumns
}

func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func findDistance(g1 []int, g2 []int) int {
	xdist := abs(g1[0] - g2[0])
	ydist := abs(g1[1] - g2[1])

	return xdist + ydist
}

func findNumberEmptyRows(g1 []int, g2 []int, emptyRows []int) int {
	n := 0
	for _, row := range emptyRows {
		if row > min(g1[0], g2[0]) && row < max(g1[0], g2[0]) {
			n++
		}
	}
	return n
}

func findNumberEmptyColumns(g1 []int, g2 []int, emptyColumns []int) int {
	n := 0
	for _, column := range emptyColumns {
		if column > min(g1[1], g2[1]) && column < max(g1[1], g2[1]) {
			n++
		}
	}
	return n
}

func findShortestPath(galaxies [][]int, emptyRows []int, emptyColumns []int) int {
	shortestPath := 0
	for x, g1 := range galaxies {
		for y, g2 := range galaxies {
			if x != y {
				dist := findDistance(g1, g2)
				nx := findNumberEmptyRows(g1, g2, emptyRows)
				ny := findNumberEmptyColumns(g1, g2, emptyColumns)
				dist = dist + nx + ny
				shortestPath += dist
			}
		}
	}
	return shortestPath / 2
}

func part1(contents string) int {
	lines := strings.Split(contents, "\n")
	galaxies := findGalaxies(lines)
	emptyRows := findEmptyRows(lines)
	emptyColumns := findEmptyColumns(lines)

	return findShortestPath(galaxies, emptyRows, emptyColumns)
}

func main() {
	contents := utils.ReadInput("sample.txt")
	fmt.Println(part1(contents))
}
