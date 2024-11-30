package main

import "core:flags"
import "core:fmt"
import "core:os"
import "core:strconv"
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

part1 :: proc(input: []u8, verbose: bool) -> int {
	it := string(input)
	sum := 0
	maxes := map[string]int {
		"red"   = 12,
		"green" = 13,
		"blue"  = 14,
	}
	defer delete(maxes)
	id := 0

	for line in strings.split_lines_iterator(&it) {
		if verbose {
			fmt.println(line)
		}

		id += 1
		valid := true

		_, _, sets := strings.partition(line, ":")
		sets = strings.trim_space(sets)
		for set in strings.split_iterator(&sets, ";") {
			set := strings.trim_space(set)
			if verbose {
				fmt.println(set)
			}

			for count in strings.split_iterator(&set, ",") {
				count := strings.trim_space(count)

				num_string, _, color := strings.partition(count, " ")
				num := strconv.atoi(num_string)
				if num > maxes[color] {
					valid = false
					break
				}
			}

			if valid == false {
				break
			}
		}

		if valid {
			sum += id
		}

		if verbose {
			fmt.println("sum: ", sum)
			fmt.println("")
		}
	}

	return sum
}

part2 :: proc(input: []u8, verbose: bool) -> int {
	return 0
}
