package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"

	"github.com/pnicto/aoc/utils"
)

func replaceWords(wordToNumber map[string]int, line string) string {
	line = regexp.MustCompile("twone").ReplaceAllString(line, "2ne")
	line = regexp.MustCompile("nineight").ReplaceAllString(line, "9ight")
	line = regexp.MustCompile("oneight").ReplaceAllString(line, "1ight")
	line = regexp.MustCompile("fiveight").ReplaceAllString(line, "5ight")
	line = regexp.MustCompile("threeight").ReplaceAllString(line, "3ight")
	for word, number := range wordToNumber {
		line = regexp.MustCompile(word).ReplaceAllString(line, strconv.Itoa(number))
	}
	return line
}

func main() {
	f, _ := os.Open("input.txt")
	temp := utils.ReadInput("input.txt")
	fmt.Println(temp)
	defer f.Close()

	wordToNumber := map[string]int{
		"one":   1,
		"two":   2,
		"three": 3,
		"four":  4,
		"five":  5,
		"six":   6,
		"seven": 7,
		"eight": 8,
		"nine":  9,
	}
	sum := 0

	re := regexp.MustCompile(`\d`)
	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := replaceWords(wordToNumber, scanner.Text())
		fmt.Println(scanner.Text())
		fmt.Println(line)
		matches := re.FindAll([]byte(line), -1)
		if matches != nil {
			if len(matches) == 1 {
				number, _ := strconv.Atoi(string(matches[0][0]))
				sum += number*10 + number
				fmt.Println(number*10 + number)
			} else {
				first, _ := strconv.Atoi(string(matches[0][0]))
				second, _ := strconv.Atoi(string(matches[len(matches)-1][0]))
				number := first*10 + second
				sum += number
				fmt.Println(number)
			}
		}
	}

	fmt.Println(sum)
}
