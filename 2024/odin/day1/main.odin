package main

import "../../../lib/odin/aoc"

import "core:flags"
import "core:fmt"
import "core:math"
import "core:os"
import "core:sort"
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

	lines := strings.split_lines(it)
	count := len(lines) - 1
	lines = lines[:count]
	defer delete(lines)

	list1 := make([]int, count)
	defer delete(list1)
	list2 := make([]int, count)
	defer delete(list2)

	for line, i in lines {
		if verbose {
			fmt.println(line)
		}

		left, _, right := strings.partition(line, "   ")
		list1[i] = strconv.atoi(left)
		list2[i] = strconv.atoi(right)
	}

	sort.quick_sort(list1)
	sort.quick_sort(list2)

	for left, i in list1 {
		sum += math.abs(left - list2[i])
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
