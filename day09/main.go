package main

import (
	"fmt"
	"strings"

	"github.com/pnicto/aoc/utils"
)

func getNums(numString string) []int {
	var nums []int

	numsStrings := strings.Split(numString, " ")
	for _, n := range numsStrings {
		nums = append(nums, utils.ToInt(n))
	}

	return nums
}

func getLastTwo(nums []int) (int, int) {
	return nums[len(nums)-1], nums[len(nums)-2]
}

func predictNext(nums []int) int {
	if nums[len(nums)-1] == 0 {
		return 0
	}

	var diff []int
	for i := 1; i < len(nums); i++ {
		diff = append(diff, nums[i]-nums[i-1])
	}

	return predictNext(diff) + nums[len(nums)-1]
}

func part1(contents string) int {
	sum := 0

	cases := strings.Split(contents, "\n")

	for _, c := range cases {
		nums := getNums(c)
		next := predictNext(nums)
		sum += next
	}

	return sum
}

func predictFirst(nums []int) int {
	if nums[len(nums)-1] == 0 {
		return nums[0]
	}

	var diff []int

	for i := 1; i < len(nums); i++ {
		diff = append(diff, nums[i]-nums[i-1])
	}

	return nums[0] - predictFirst(diff)
}

func part2(contents string) int {
	sum := 0

	cases := strings.Split(contents, "\n")

	for _, c := range cases {
		nums := getNums(c)
		first := predictFirst(nums)
		sum += first
	}

	return sum
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
	fmt.Println(part2(contents))
}
