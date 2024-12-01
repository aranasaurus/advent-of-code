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

	list1, list2 := get_lists(it, verbose)
	defer delete(list1)
	defer delete(list2)

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

	list1, list2 := get_lists(it, verbose)
	defer delete(list1)
	defer delete(list2)

	counts := make(map[int]int)
	defer delete(counts)
	for right in list2 {
		counts[right] += 1
	}

	for left in list1 {
		sum += left * counts[left]
	}

	return sum
}

get_lists :: proc(input: string, verbose: bool) -> ([]int, []int) {
	lines := strings.split_lines(input)
	count := len(lines) - 1
	lines = lines[:count]
	defer delete(lines)

	list1 := make([]int, count)
	list2 := make([]int, count)

	for line, i in lines {
		if verbose {
			fmt.println(line)
		}

		left, _, right := strings.partition(line, "   ")
		list1[i] = strconv.atoi(left)
		list2[i] = strconv.atoi(right)
	}

	return list1, list2
}
