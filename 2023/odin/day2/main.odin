package main

import "../../../lib/odin/aoc"
import "core:flags"
import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, opt := aoc.parse()
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
	it := string(input)
	sum := 0

	for line in strings.split_lines_iterator(&it) {
		if verbose {
			fmt.println(line)
		}

		reqs := map[string]int {
			"red"   = 0,
			"green" = 0,
			"blue"  = 0,
		}
		defer delete(reqs)

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
				if num > reqs[color] {
					reqs[color] = num
				}
			}
		}

		if reqs["red"] == 0 {
			reqs["red"] = 1
		}
		if reqs["green"] == 0 {
			reqs["green"] = 1
		}
		if reqs["blue"] == 0 {
			reqs["blue"] = 1
		}

		if verbose {
			fmt.println(reqs)
		}

		power := reqs["red"] * reqs["green"] * reqs["blue"]
		sum += power

		if verbose {
			fmt.println("pow: ", power)
			fmt.println("sum: ", sum)
			fmt.println("")
		}
	}

	return sum
}
