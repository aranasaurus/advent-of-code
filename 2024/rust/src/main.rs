use std::fs;

use nom::{
    branch::alt,
    bytes::complete::{tag, take, take_until},
    character::complete,
    combinator::{map_opt, value, verify},
    multi::{many0, many_till},
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
    let file = fs::read_to_string(args.input.clone()).expect("Failed to open input file");
    let result = run(&file, args).expect("Failed to run solution");
    println!("{result}")
}

#[derive(Debug)]
enum Error {
    InvalidArgument,
}

fn run(input_string: &str, args: Args) -> Result<u32, Error> {
    match args.part {
        1 => {
            let result = many0(parse_next_mul)(&input_string)
                .unwrap()
                .1
                .iter()
                .map(|item| item.0 * item.1)
                .fold(0u32, |sum, n| sum + n);
            Ok(result)
        }
        2 => {
            let result = many0(many_till(complete::anychar, instruction))(&input_string)
                .unwrap()
                .1
                .iter()
                .fold((true, 0u32), |result, item| match item.1 {
                    Instruction::Mul(a, b) => {
                        if result.0 {
                            (result.0, result.1 + a * b)
                        } else {
                            result
                        }
                    }
                    Instruction::Dont => (false, result.1),
                    Instruction::Do => (true, result.1),
                });
            Ok(result.1)
        }
        _ => Err(Error::InvalidArgument),
    }
}

#[derive(Debug, Clone, Copy)]
enum Instruction {
    Mul(u32, u32),
    Do,
    Dont,
}

fn instruction(input: &str) -> IResult<&str, Instruction> {
    alt((
        value(Instruction::Do, tag("do()")),
        value(Instruction::Dont, tag("don't()")),
        mul,
    ))(input)
}

fn mul(input: &str) -> IResult<&str, Instruction> {
    let (input, result) = verify(
        delimited(
            tag("mul("),
            separated_pair(complete::u32, complete::char(','), complete::u32),
            complete::char(')'),
        ),
        |result| result.0 < 1000 && result.1 < 1000,
    )(input)?;
    Ok((input, Instruction::Mul(result.0, result.1)))
}

fn parse_next_mul(input: &str) -> IResult<&str, (u32, u32)> {
    let (input, _) = take_until("mul(")(input)?;
    alt((
        verify(
            delimited(
                tag("mul("),
                separated_pair(complete::u32, complete::char(','), complete::u32),
                complete::char(')'),
            ),
            |numbers: &(u32, u32)| numbers.0 < 1000 && numbers.1 < 1000,
        ),
        map_opt(take(4usize), |_| Some((0u32, 0u32))),
    ))(input)
}

#[cfg(test)]
mod tests {
    use std::io;

    use super::*;

    #[test]
    fn test_part1_example() -> io::Result<()> {
        let file = fs::read_to_string("src/day3/example")?;
        assert_eq!(
            161,
            run(
                &file,
                Args {
                    input: "input".to_string(),
                    part: 1,
                },
            )
            .unwrap()
        );
        Ok(())
    }

    #[test]
    fn test_part1_input() -> io::Result<()> {
        let file = fs::read_to_string("src/day3/input")?;
        assert_eq!(
            178886550,
            run(
                &file,
                Args {
                    input: "input".to_string(),
                    part: 1,
                },
            )
            .unwrap()
        );
        Ok(())
    }

    #[test]
    fn test_part2_example() -> io::Result<()> {
        let file = fs::read_to_string("src/day3/example2")?;
        assert_eq!(
            48,
            run(
                &file,
                Args {
                    input: "input".to_string(),
                    part: 2,
                },
            )
            .unwrap()
        );
        Ok(())
    }
    #[test]
    fn test_part2_input() -> io::Result<()> {
        let file = fs::read_to_string("src/day3/input")?;
        assert_eq!(
            87163705,
            run(
                &file,
                Args {
                    input: "input".to_string(),
                    part: 2,
                },
            )
            .unwrap()
        );
        Ok(())
    }
}
