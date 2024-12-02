package main

import "../../../lib/odin/aoc"

import "core:flags"
import "core:fmt"
import "core:os"
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
