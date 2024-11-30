package main

import (
	"fmt"
	"log"
	"regexp"
	"strconv"
	"strings"
	"unicode"

	"github.com/pnicto/aoc/utils"
	"golang.org/x/exp/slices"
)

func isPartNumber(cx int, cy int, splits []string) bool {
	dx := []int{-1, 0, 1, -1, 1, -1, 0, 1}
	dy := []int{1, 1, 1, 0, 0, -1, -1, -1}

	for i := 0; i < len(dx); i++ {
		nx := cx + dx[i]
		ny := cy + dy[i]

		if !(nx < 0 || ny < 0 || nx >= len(splits) || ny >= len(splits[nx])) {
			if splits[nx][ny] != '.' && !unicode.IsDigit(rune(splits[nx][ny])) {
				return true
			}
		}

	}
	return false
}

func findGearNumbers(cx int, cy int, splits []string) (bool, int, int) {
	dx := []int{-1, 0, 1, -1, 1, -1, 0, 1}
	dy := []int{1, 1, 1, 0, 0, -1, -1, -1}

	for i := 0; i < len(dx); i++ {
		nx := cx + dx[i]
		ny := cy + dy[i]

		if !(nx < 0 || ny < 0 || nx >= len(splits) || ny >= len(splits[nx])) {
			if splits[nx][ny] == '*' {
				return true, nx, ny
			}
		}
	}

	return false, -1, -1
}

func part1(contents string) int {
	sum := 0
	re := regexp.MustCompile(`\d+`)
	matches := re.FindAllStringIndex(contents, -1)
	nums := re.FindAllString(contents, -1)

	splits := strings.Split(contents, "\n")

	isParts := []bool{}

	for i := range splits {
		for j := range splits[i] {
			if unicode.IsDigit(rune(splits[i][j])) {
				isParts = append(isParts, isPartNumber(i, j, splits))
			}
		}
	}

	idx := 0

	for i, match := range matches {
		length := match[1] - match[0]
		if slices.Contains((isParts[idx : idx+length]), true) {
			num, err := strconv.Atoi(nums[i])
			if err != nil {
				log.Fatalln(err, nums[i])
			}
			sum += num
		}
		idx += length
	}

	return sum
}

type NumberGearIndex struct {
	isPart bool
	gearX  int
	gearY  int
}

type GearNumber struct {
	num int
	gx  int
	gy  int
}

func part2(contents string) int {
	gearRatio := 0
	re := regexp.MustCompile(`\d+`)
	matches := re.FindAllStringIndex(contents, -1)
	nums := re.FindAllString(contents, -1)

	splits := strings.Split(contents, "\n")

	isParts := []NumberGearIndex{}

	for i := range splits {
		for j := range splits[i] {
			if unicode.IsDigit(rune(splits[i][j])) {
				var gearNumber NumberGearIndex
				isGear, gx, gy := findGearNumbers(i, j, splits)
				gearNumber.isPart = isGear
				gearNumber.gearX = gx
				gearNumber.gearY = gy

				isParts = append(isParts, gearNumber)
			}
		}
	}

	idx := 0

	lookup := make(map[int]map[int][]int)

	for i, match := range matches {
		length := match[1] - match[0]
		for _, g := range isParts[idx : idx+length] {
			if g.isPart {
				num, _ := strconv.Atoi(nums[i])
				if lookup[g.gearX] == nil {
					lookup[g.gearX] = make(map[int][]int)
				}
				lookup[g.gearX][g.gearY] = append(lookup[g.gearX][g.gearY], num)
				break
			}
		}

		idx += length
	}

	for _, col := range lookup {
		for _, nums := range col {
			if len(nums) == 2 {
				gearRatio += nums[0] * nums[1]
			}
		}
	}

	return gearRatio
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
	fmt.Println(part2(contents))
}
