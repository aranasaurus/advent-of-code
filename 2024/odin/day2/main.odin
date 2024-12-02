package main

import "../../../lib/odin/aoc"

import "core:flags"
import "core:fmt"
import "core:math"
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
	for line in strings.split_lines_iterator(&it) {
		if verbose {
			fmt.println(line)
		}

		if is_safe(line, verbose) {
			sum += 1
		}

		if verbose {
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
	}
	return sum
}

is_safe :: proc(report: string, verbose: bool) -> bool {
	levels := strings.split(report, " ")
	ascending: bool

	for i := 0; i < len(levels) - 1; i += 1 {
		level := strconv.atoi(levels[i])
		next_level := strconv.atoi(levels[i + 1])
		dist := next_level - level

		if i == 0 {
			ascending = level < next_level
			if verbose {
				fmt.println(ascending ? "ascending" : "descending")
			}
		}

		if verbose {
			fmt.println(level, next_level, dist)
		}

		if level == next_level {
			if verbose {
				fmt.println("unsafe: equal")
			}
			return false
		}

		if ascending {
			if dist < 0 {
				if verbose {
					fmt.println("unsafe: not all ascending")
				}
				return false
			}
		} else if dist > 0 {
			if verbose {
				fmt.println("unsafe: not all descending")
			}
			return false
		}

		if math.abs(dist) > 3 {
			if verbose {
				fmt.println("unsafe: too large jump")
			}
			return false
		}
	}

	if verbose {
		fmt.println("safe")
	}
	return true
}
