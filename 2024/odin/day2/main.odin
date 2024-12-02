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

		if is_safe(line, verbose) {
			sum += 1
		}

		if verbose {
			fmt.println("")
		}
	}
	return sum
}

is_safe :: proc(report: string, verbose: bool, skip_index: int = -1) -> bool {
	levels := strings.split(report, " ")
	ascending: bool

	for i := 0; i < len(levels) - 1; i += 1 {
		level := strconv.atoi(levels[i])
		next_level := strconv.atoi(levels[i + 1])
		dist := next_level - level

		if i == 0 { 	//|| (skip_index == 0 && i == 1) {
			ascending = level < next_level
			if verbose {
				fmt.println(ascending ? "ascending" : "descending")
			}
		}

		if verbose {
			fmt.println(level, next_level)
		}

		if level == next_level {
			if verbose {
				fmt.println("unsafe: equal")
			}
			return dampen(levels, skip_index, len(levels), verbose)
		}

		if ascending {
			if dist < 0 {
				if verbose {
					fmt.println("unsafe: not all ascending")
				}
				return dampen(levels, skip_index, len(levels), verbose)
			}
		} else if dist > 0 {
			if verbose {
				fmt.println("unsafe: not all descending")
			}
			return dampen(levels, skip_index, len(levels), verbose)
		}

		if math.abs(dist) > 3 {
			if verbose {
				fmt.println("unsafe: too large jump")
			}
			return dampen(levels, skip_index, len(levels), verbose)
		}
	}

	if verbose {
		fmt.println("safe")
	}
	return true
}

dampen :: proc(levels: []string, skip_index: int, count: int, verbose: bool) -> bool {
	if skip_index < 0 {
		for i in 0 ..< count {
			dampened := make([dynamic]string)
			defer delete(dampened)

			for level in levels[:i] {
				append(&dampened, level)
			}
			for level in levels[i + 1:] {
				append(&dampened, level)
			}
			dampened_report := strings.join(dampened[:], " ")
			if verbose {
				fmt.println("dampening")
				fmt.println(dampened_report)
			}
			if is_safe(strings.join(dampened[:], " "), verbose, i) {
				return true
			}
		}
	}
	return false
}
