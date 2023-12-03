package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

func replaceWords(line string) string {
	line = regexp.MustCompile("twone").ReplaceAllString(line, "twoone")
	line = regexp.MustCompile("oneight").ReplaceAllString(line, "oneeight")
	line = regexp.MustCompile("threeight").ReplaceAllString(line, "threeeight")
	line = regexp.MustCompile("fiveight").ReplaceAllString(line, "fiveeight")
	line = regexp.MustCompile("eightwo").ReplaceAllString(line, "eighttwo")
	line = regexp.MustCompile("eighthree").ReplaceAllString(line, "eightthree")

	line = regexp.MustCompile("one").ReplaceAllString(line, "1")
	line = regexp.MustCompile("two").ReplaceAllString(line, "2")
	line = regexp.MustCompile("three").ReplaceAllString(line, "3")
	line = regexp.MustCompile("four").ReplaceAllString(line, "4")
	line = regexp.MustCompile("five").ReplaceAllString(line, "5")
	line = regexp.MustCompile("six").ReplaceAllString(line, "6")
	line = regexp.MustCompile("seven").ReplaceAllString(line, "7")
	line = regexp.MustCompile("eight").ReplaceAllString(line, "8")
	line = regexp.MustCompile("nine").ReplaceAllString(line, "9")
	return line
}

func main() {
	f, _ := os.Open("input.txt")
	defer f.Close()
	sum := 0

	re := regexp.MustCompile(`\d`)
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		// part 1
		// line := scanner.Text()

		// part 2
		line := replaceWords(scanner.Text())

		matches := re.FindAll([]byte(line), -1)
		if matches != nil {
			if len(matches) == 1 {
				number, _ := strconv.Atoi(string(matches[0][0]))
				sum += number*10 + number
			} else {
				first, _ := strconv.Atoi(string(matches[0][0]))
				second, _ := strconv.Atoi(string(matches[len(matches)-1][0]))
				number := first*10 + second
				sum += number
			}
		}
	}

	fmt.Println(sum)
}
