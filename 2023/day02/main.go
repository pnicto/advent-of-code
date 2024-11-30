package main

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	"github.com/pnicto/aoc/utils"
)

type Set struct {
	red   int
	green int
	blue  int
}

func getGameID(game string) int {
	gameID := strings.Fields(game)[1]
	gameID = gameID[:len(gameID)-1]
	ID, err := strconv.Atoi(gameID)
	if err != nil {
		log.Fatalln(err, game)
	}
	return ID
}

func stripGameID(game string) string {
	fields := strings.Fields(game)[2:]
	return strings.Join(fields, " ")
}

func extractCubeCounts(set string) Set {
	var cube Set
	colors := strings.Split(set, ", ")
	for _, color := range colors {
		color = strings.TrimSpace(color)
		colorString := strings.Fields(color)[0]
		count, err := strconv.Atoi(colorString)
		if err != nil {
			log.Fatalln(err, set)
		}
		if strings.HasSuffix(color, "red") {
			cube.red = count
		} else if strings.HasSuffix(color, "green") {
			cube.green = count
		} else if strings.HasSuffix(color, "blue") {
			cube.blue = count
		}
	}
	return cube
}

// part 1
func sumID(contents string, limits Set) int {
	games := strings.Split(contents, "\n")
	sum := 0
	for _, game := range games {
		gameID := getGameID(game)
		game = stripGameID(game)
		sets := strings.Split(game, "; ")
		isPossible := true
		for _, set := range sets {
			cube := extractCubeCounts(set)
			if cube.red > limits.red || cube.green > limits.green || cube.blue > limits.blue {
				isPossible = false
				break
			}
		}

		if isPossible {
			sum += gameID
		}
	}
	return sum
}

// part 2
func sumMinCubeProduct(contents string) int {
	games := strings.Split(contents, "\n")
	sum := 0

	for _, game := range games {
		game = stripGameID(game)
		sets := strings.Split(game, "; ")
		var minCube Set
		for _, set := range sets {
			cube := extractCubeCounts(set)
			if cube.red > minCube.red {
				minCube.red = cube.red
			}
			if cube.blue > minCube.blue {
				minCube.blue = cube.blue
			}
			if cube.green > minCube.green {
				minCube.green = cube.green
			}
		}
		sum += minCube.red * minCube.blue * minCube.green
	}

	return sum
}

func main() {
	contents := utils.ReadInput("input.txt")
	limits := Set{12, 13, 14}
	fmt.Println(sumID(contents, limits))
	fmt.Println(sumMinCubeProduct(contents))
}
