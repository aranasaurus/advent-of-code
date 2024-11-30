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
	return 0
}

part2 :: proc(input: []u8, verbose: bool) -> int {
	return 0
}
