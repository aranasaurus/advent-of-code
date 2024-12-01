package aoc

import "core:flags"
import "core:fmt"
import "core:os"

Part :: enum {
	p1,
	p2,
}

Options :: struct {
	part:  Part `args:"pos=0,required" usage: "Which part to run."`,
	input: string `args:"pos=1,required" usage:"Input file."`,
	v:     bool `usage:"Show verbose output."`,
}

main :: proc() {}

parse :: proc() -> (data: []u8, opt: Options) {
	style: flags.Parsing_Style = .Odin

	flags.parse_or_exit(&opt, os.args, style)

	input, err := os.read_entire_file_or_err(opt.input, context.allocator)
	if err != nil {
		// could not read file
		fmt.println(err)
		os.exit(1)
	}

	return input, opt
}
