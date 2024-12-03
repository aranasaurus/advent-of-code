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

		if is_safe(line, verbose, false) {
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

		if is_safe(line, verbose, true) {
			sum += 1
		}

		if verbose {
			fmt.println("")
		}
	}
	return sum
}

is_safe :: proc(report: string, verbose: bool, dampener_enabled: bool) -> bool {
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
			fmt.println(level, next_level)
		}

		if level == next_level {
			if verbose {
				fmt.println("unsafe: equal")
			}
			return dampen(levels, dampener_enabled, i, len(levels), verbose)
		}

		if ascending {
			if dist < 0 {
				if verbose {
					fmt.println("unsafe: not all ascending")
				}
				return dampen(levels, dampener_enabled, i, len(levels), verbose)
			}
		} else if dist > 0 {
			if verbose {
				fmt.println("unsafe: not all descending")
			}
			return dampen(levels, dampener_enabled, i, len(levels), verbose)
		}

		if math.abs(dist) > 3 {
			if verbose {
				fmt.println("unsafe: too large jump")
			}
			return dampen(levels, dampener_enabled, i, len(levels), verbose)
		}
	}

	if verbose {
		fmt.println("safe")
	}
	return true
}

dampen :: proc(
	levels: []string,
	dampener_enabled: bool,
	err_index: int,
	count: int,
	verbose: bool,
) -> bool {
	if dampener_enabled {
		// Try removing levels in the following order. If one succeeds the others won't be attempted.
		indices_to_remove := [3]int {
			// The first level in the pair that caused the error
			err_index,
			// The second level in the pair that caused the error
			err_index + 1,
			// The first level in the report. Edge-case where the first pair is in a different order than the rest.
			0,
		}

		for i in indices_to_remove {
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

			if is_safe(strings.join(dampened[:], " "), verbose, false) {
				return true
			}
		}
	}
	return false
}
