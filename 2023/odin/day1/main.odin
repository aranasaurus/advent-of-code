package main

import "core:flags"
import "core:fmt"
import "core:os"
import "core:strings"

Part :: enum {
	p1,
	p2,
}

Options :: struct {
	part:  Part `args:"pos=0,required" usage: "Which part to run."`,
	input: string `args:"pos=1,required" usage:"Input file."`,
	v:     bool `usage:"Show verbose output."`,
}

numbers := "0123456789"
words := []string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

main :: proc() {
	opt: Options
	style: flags.Parsing_Style = .Odin

	flags.parse_or_exit(&opt, os.args, style)

	data, ok := os.read_entire_file(opt.input, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	sum: int
	switch opt.part {
	case .p1:
		sum = part1(data, opt.v)
	case .p2:
		sum = part2(data, opt.v)
	}

	fmt.println("answer:", sum)
}

part2 :: proc(input: []u8, verbose: bool) -> int {
	it := string(input)
	sum := 0
	for line in strings.split_lines_iterator(&it) {
		if verbose {
			fmt.println(line)
		}

		first := first_num(line) * 10
		last := last_num(line)
		if verbose {
			fmt.println(sum, "+ (", first, "+", last, ")")
		}

		sum += first + last
	}
	return sum
}

part1 :: proc(input: []u8, verbose: bool) -> int {
	it := string(input)
	sum := 0
	for line in strings.split_lines_iterator(&it) {
		if verbose {
			fmt.println(line)
		}

		first := line[strings.index_any(line, numbers)] - '0'
		last := line[strings.last_index_any(line, numbers)] - '0'
		num := (10 * first) + last
		if verbose {
			fmt.println(num)
		}

		sum += int(num)
	}
	return sum
}

num_from_word :: proc(word: string) -> int {
	switch word {
	case "one":
		return 1
	case "two":
		return 2
	case "three":
		return 3
	case "four":
		return 4
	case "five":
		return 5
	case "six":
		return 6
	case "seven":
		return 7
	case "eight":
		return 8
	case "nine":
		return 9
	case:
		return -1
	}
}

first_num :: proc(line: string) -> int {
	first_lit_i := -1
	first_lit_num := -1
	for r, i in line {
		if strings.contains_rune(numbers, r) {
			first_lit_i = i
			first_lit_num = int(line[first_lit_i] - '0')
			break
		}
	}

	first_word_i := 1000
	first_word_num := -1
	for word in words {
		i := strings.index(line, word)
		if i != -1 && i < first_word_i {
			first_word_i = i
			first_word_num = num_from_word(word)
		}
	}

	if first_word_i != -1 && first_lit_i != -1 {
		// we have both literal numbers and word numbers, use whichever came first
		if first_lit_i < first_word_i {
			return first_lit_num
		} else {
			return first_word_num
		}
	} else if first_word_i != -1 {
		// we have a line with only words
		return first_word_num
	} else {
		return first_lit_num
	}
}

last_num :: proc(line: string) -> int {
	last_lit_i := -1
	last_lit_num := -1
	#reverse for r, i in line {
		if strings.contains_rune(numbers, r) {
			last_lit_i = i
			last_lit_num = int(line[last_lit_i] - '0')
			break
		}
	}

	last_word_i := -1
	last_word_num := -1
	for word in words {
		i := strings.last_index(line, word)
		if i != -1 && i > last_word_i {
			last_word_i = i
			last_word_num = num_from_word(word)
		}
	}

	if last_word_i != -1 && last_lit_i != -1 {
		if last_lit_i > last_word_i {
			return last_lit_num
		} else {
			return last_word_num
		}
	} else if last_word_i != -1 {
		return last_word_num
	} else {
		return last_lit_num
	}
}
