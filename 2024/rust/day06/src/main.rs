use std::fs;

use clap::Parser;

fn run(input_string: &str, part: u8) -> Result<String, Error> {
    match part {
        1 => Ok(part1(&input_string)),
        2 => Ok(part2(&input_string)),
        _ => Err(Error::InvalidPart),
    }
}

fn part1(input_string: &str) -> String {
    todo!("day06 part 1")
}

fn part2(input_string: &str) -> String {
    todo!("day06 part 2")
}

#[cfg(test)]
mod day06_tests {
    use std::io;

    use super::*;

    #[test]
    fn test_part1_example() -> io::Result<()> {
        let file = read_file("inputs/example".to_string());
        assert_eq!("TODO!", run(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part1_input() -> io::Result<()> {
        let file = read_file("inputs/input".to_string());
        assert_eq!("TODO!", run(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part2_example() -> io::Result<()> {
        let file = read_file("inputs/example".to_string());
        assert_eq!("TODO!", run(&file, 2).unwrap());
        Ok(())
    }

    #[test]
    fn test_part2_input() -> io::Result<()> {
        let file = read_file("inputs/input".to_string());
        assert_eq!("TODO!", run(&file, 2).unwrap());
        Ok(())
    }
}

fn main() {
    let args = Args::parse();
    let file_contents = read_file(args.input);
    let result = run(&file_contents, args.part).expect("Failed to run solution");
    println!("{result}")
}

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

fn read_file(path: String) -> String {
    fs::read_to_string(path).expect("Failed to open input file")
}


#[derive(Debug)]
enum Error {
    InvalidPart,
}
