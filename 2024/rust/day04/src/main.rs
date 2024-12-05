use std::fs;

use clap::Parser;

fn run(input_string: &str, part: u8) -> Result<String, Error> {
    match part {
        1 => Ok(word_search(&input_string).to_string()),
        2 => Ok(xmas_search(&input_string).to_string()),
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

fn xmas_search(input_string: &str) -> u32 {
    let grid: Vec<Vec<char>> = input_string
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    let mut result = 0u32;
    for y in 0..grid.len() {
        for x in 0..grid[y].len() {
            if grid[y][x] == 'A' {
                result += score_mas(&grid, x, y)
            }
        }
    }
    dbg!(result);
    result
}

fn score_mas(grid: &Vec<Vec<char>>, x: usize, y: usize) -> u32 {
    if x < 1 || x > grid[y].len() - 2 || y < 1 || y > grid.len() - 2 {
        return 0;
    }

    let corners = [
        grid[y - 1][x - 1],
        grid[y - 1][x + 1],
        grid[y + 1][x + 1],
        grid[y + 1][x - 1],
    ];

    // There's probably a smarter way to do this
    match corners[..] {
        ['M', 'S', 'S', 'M'] => 1,
        ['M', 'M', 'S', 'S'] => 1,
        ['S', 'M', 'M', 'S'] => 1,
        ['S', 'S', 'M', 'M'] => 1,
        _ => 0,
    }
}

#[cfg(test)]
mod day04_tests {
    use std::io;

    use super::*;

    #[test]
    fn test_part1_example() -> io::Result<()> {
        let file = read_file("inputs/example".to_string());
        assert_eq!("18", run(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part1_input() -> io::Result<()> {
        let file = read_file("inputs/input".to_string());
        assert_eq!("2547", run(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part2_example() -> io::Result<()> {
        let file = read_file("inputs/example".to_string());
        assert_eq!("9", run(&file, 2).unwrap());
        Ok(())
    }

    #[test]
    fn test_part2_input() -> io::Result<()> {
        let file = read_file("inputs/input".to_string());
        assert_eq!("1939", run(&file, 2).unwrap());
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
