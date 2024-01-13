package main

import (
	"fmt"
	"strings"

	"github.com/pnicto/aoc/utils"
)

func hash(input string) int {
	currentValue := 0

	for _, char := range input {
		currentValue += int(char)
		currentValue *= 17
		currentValue %= 256
	}

	return currentValue
}

func part1(contents string) int {
	res := 0
	inputs := strings.Split(contents, ",")

	for _, input := range inputs {
		res += hash(input)
	}

	return res
}

type Data struct {
	value     *int
	label     string
	operation string
}

type Lookup struct {
	lookup map[int][]Data
}

func (l *Lookup) remove(boxNo int, label string) {
	boxes := l.lookup[boxNo]
	for i, box := range boxes {
		if box.label == label {
			boxes = append(boxes[:i], boxes[i+1:]...)
			break
		}
	}

	l.lookup[boxNo] = boxes
}

func (l *Lookup) add(boxNo int, data Data) {
	boxes := l.lookup[boxNo]

	found := false
	for i, box := range boxes {
		if box.label == data.label {
			box.value = data.value
			boxes[i] = box
			found = true
			break
		}
	}

	if !found {
		boxes = append(boxes, data)
	}

	l.lookup[boxNo] = boxes
}

func (l *Lookup) getFocusingPower() int {
	focusingPower := 0

	for boxNo, boxes := range l.lookup {
		if len(boxes) > 0 {
			for slotNo, box := range boxes {
				focusingPower += (1 + boxNo) * (slotNo + 1) * (*box.value)
			}
		}
	}

	return focusingPower
}

func part2(contents string) int {
	var l Lookup
	l.lookup = make(map[int][]Data)

	inputs := strings.Split(contents, ",")

	for _, input := range inputs {
		var data Data
		if strings.Contains(input, "=") {
			// additive
			splits := strings.Split(input, "=")

			data.label = splits[0]
			data.operation = "="
			data.value = new(int)
			*data.value = utils.ToInt(splits[1])
		} else {
			// subtractive
			splits := strings.Split(input, "-")
			data.label = splits[0]
			data.operation = "-"
			data.value = nil
		}

		boxNo := hash(data.label)

		if data.operation == "-" {
			l.remove(boxNo, data.label)
		} else {
			l.add(boxNo, data)
		}
	}

	return l.getFocusingPower()
}

func main() {
	contents := utils.ReadInput("input.txt")
	fmt.Println(part1(contents))
	fmt.Println(part2(contents))
}
