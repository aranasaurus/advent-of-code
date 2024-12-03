use std::fs;

use nom::{
    branch::alt,
    bytes::complete::{tag, take, take_until},
    character::complete::{char, u32},
    combinator::{map_opt, verify},
    multi::many0,
    sequence::{delimited, separated_pair},
    IResult,
};

use clap::Parser;

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// The part to run (1 or 2)
    #[arg(short, long, default_value_t = 1u8)]
    part: u8,

    /// Input file to run on
    #[arg(short, long)]
    input: String,
}

fn main() {
    let args = Args::parse();
    let file = fs::read_to_string(args.input).unwrap();

    let result = many0(parse_next_mul)(&file)
        .unwrap()
        .1
        .iter()
        .map(|item| item.0 * item.1)
        .fold(0u32, |sum, n| sum + n);
    dbg!(result);
}

fn parse_next_mul(input: &str) -> IResult<&str, (u32, u32)> {
    let (input, _) = take_until("mul(")(input)?;
    alt((
        verify(
            delimited(tag("mul("), separated_pair(u32, char(','), u32), char(')')),
            |numbers: &(u32, u32)| numbers.0 < 1000 && numbers.1 < 1000,
        ),
        map_opt(take(4usize), |_| Some((0u32, 0u32))),
    ))(input)
}
