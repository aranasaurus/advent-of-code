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

    /// The day to run (1 ..= 25)
    #[arg(short, long, default_value_t = 1u8)]
    day: u8,

    /// Input file to run on
    #[arg(short, long)]
    input: String,
}

fn read_file(path: String) -> String {
    fs::read_to_string(path).expect("Failed to open input file")
}

fn main() {
    let args = Args::parse();
    let file_contents = read_file(args.input);
    let result = run(&file_contents, args.day, args.part).expect("Failed to run solution");
    println!("{result}")
}

#[derive(Debug)]
enum Error {
    InvalidPart,
    InvalidDay,
}

fn run(input_string: &str, day: u8, part: u8) -> Result<String, Error> {
    match day {
        1..=2 | 5..=25 => todo!(),
        3 => day3(&input_string, part),
        4 => day4(&input_string, part),
        _ => Err(Error::InvalidDay),
    }
}

fn day4(input_string: &str, part: u8) -> Result<String, Error> {
    match part {
        1 => Ok(word_search(&input_string).to_string()),
        2 => todo!(),
        _ => Err(Error::InvalidPart),
    }
}

fn word_search(input_string: &str) -> u32 {
    let grid: Vec<Vec<usize>> = input_string
        .lines()
        .map(|line| {
            line.chars()
                .map(|c| match c {
                    'X' => 1usize,
                    'M' => 2usize,
                    'A' => 3usize,
                    'S' => 4usize,
                    _ => 0usize,
                })
                .collect()
        })
        .collect();

    let mut result = 0u32;
    for y in 0..grid.len() {
        for x in 0..grid[y].len() {
            if grid[y][x] == 1 {
                result += score_x(&grid, x, y)
            }
        }
    }
    dbg!(result);
    result
}

fn score_x(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> u32 {
    let mut score = 0u32;
    if check_n(&grid, x, y) {
        score += 1
    }
    if check_ne(&grid, x, y) {
        score += 1
    }
    if check_e(&grid, x, y) {
        score += 1
    }
    if check_se(&grid, x, y) {
        score += 1
    }
    if check_s(&grid, x, y) {
        score += 1
    }
    if check_sw(&grid, x, y) {
        score += 1
    }
    if check_w(&grid, x, y) {
        score += 1
    }
    if check_nw(&grid, x, y) {
        score += 1
    }
    score
}

const WORD_LEN: usize = 4;
fn check_n(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if y < WORD_LEN - 1 {
        return false;
    }

    #[rustfmt::skip]
    let word = vec![
        grid[y][x],
        grid[y - 1][x],
        grid[y - 2][x],
        grid[y - 3][x],
    ];

    word == vec![1, 2, 3, 4]
}

fn check_ne(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if y < WORD_LEN - 1 || x > grid[y].len() - WORD_LEN {
        return false;
    }

    let word = vec![
        grid[y][x],
        grid[y - 1][x + 1],
        grid[y - 2][x + 2],
        grid[y - 3][x + 3],
    ];

    word == vec![1, 2, 3, 4]
}

fn check_e(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if x > grid[y].len() - WORD_LEN {
        return false;
    }

    #[rustfmt::skip]
    let word = vec![
        grid[y][x],
        grid[y][x + 1],
        grid[y][x + 2],
        grid[y][x + 3],
    ];

    word == vec![1, 2, 3, 4]
}

fn check_se(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if y > grid.len() - WORD_LEN || x > grid[y].len() - WORD_LEN {
        return false;
    }

    let word = vec![
        grid[y][x],
        grid[y + 1][x + 1],
        grid[y + 2][x + 2],
        grid[y + 3][x + 3],
    ];

    word == vec![1, 2, 3, 4]
}

fn check_s(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if y > grid.len() - WORD_LEN {
        return false;
    }

    #[rustfmt::skip]
    let word = vec![
        grid[y][x],
        grid[y + 1][x],
        grid[y + 2][x],
        grid[y + 3][x],
    ];

    word == vec![1, 2, 3, 4]
}

fn check_sw(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if x < WORD_LEN - 1 || y > grid.len() - WORD_LEN {
        return false;
    }

    let word = vec![
        grid[y][x],
        grid[y + 1][x - 1],
        grid[y + 2][x - 2],
        grid[y + 3][x - 3],
    ];

    word == vec![1, 2, 3, 4]
}

fn check_w(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if x < WORD_LEN - 1 {
        return false;
    }

    #[rustfmt::skip]
    let word = vec![
        grid[y][x],
        grid[y][x - 1],
        grid[y][x - 2],
        grid[y][x - 3],
    ];

    word == vec![1, 2, 3, 4]
}

fn check_nw(grid: &Vec<Vec<usize>>, x: usize, y: usize) -> bool {
    if x < WORD_LEN - 1 || y < WORD_LEN - 1 {
        return false;
    }

    #[rustfmt::skip]
    let word = vec![
        grid[y][x],
        grid[y - 1][x - 1],
        grid[y - 2][x - 2],
        grid[y - 3][x - 3],
    ];

    word == vec![1, 2, 3, 4]
}

fn day3(input_string: &str, part: u8) -> Result<String, Error> {
    match part {
        1 => {
            let result = many0(parse_next_mul)(&input_string)
                .unwrap()
                .1
                .iter()
                .map(|item| item.0 * item.1)
                .fold(0u32, |sum, n| sum + n);
            Ok(result.to_string())
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
            Ok(result.1.to_string())
        }
        _ => Err(Error::InvalidPart),
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
mod day3_tests {
    use std::io;

    use super::*;

    #[test]
    fn test_part1_example() -> io::Result<()> {
        let file = read_file("src/day3/example".to_string());
        assert_eq!("161", day3(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part1_input() -> io::Result<()> {
        let file = read_file("src/day3/input".to_string());
        assert_eq!("178886550", day3(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part2_example() -> io::Result<()> {
        let file = read_file("src/day3/example2".to_string());
        assert_eq!("48", day3(&file, 2).unwrap());
        Ok(())
    }
    #[test]
    fn test_part2_input() -> io::Result<()> {
        let file = read_file("src/day3/input".to_string());
        assert_eq!("87163705", day3(&file, 2).unwrap());
        Ok(())
    }
}

#[cfg(test)]
mod day4_tests {
    use std::io;

    use super::*;

    #[test]
    fn test_part1_example() -> io::Result<()> {
        let file = read_file("src/day4/example1".to_string());
        assert_eq!("18", day4(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part1_input() -> io::Result<()> {
        let file = read_file("src/day4/input".to_string());
        assert_eq!("2547", day4(&file, 1).unwrap());
        Ok(())
    }
}
