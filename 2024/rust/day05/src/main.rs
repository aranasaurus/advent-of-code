use std::{collections::HashMap, fs};

use clap::Parser;

fn run(input_string: &str, part: u8) -> Result<String, Error> {
    match part {
        1 => Ok(part1(&input_string)),
        2 => Ok(part2(&input_string)),
        _ => Err(Error::InvalidPart),
    }
}

fn part1(input_string: &str) -> String {
    // page_map maps pages to all the pages they must come before
    let mut page_map = HashMap::new();
    let mut valid_updates: Vec<&str> = vec![];

    for line in input_string
        .lines()
        .filter(|line| !line.is_empty())
        .into_iter()
    {
        if let Some(rule) = line.split_once("|") {
            if !page_map.contains_key(rule.0) {
                page_map.insert(rule.0, vec![rule.1]);
            } else {
                let pages_after = page_map.get_mut(rule.0).unwrap();
                pages_after.insert(pages_after.len(), rule.1);
            }
        } else {
            let mut valid = true;

            line.split(",")
                .into_iter()
                .enumerate()
                .for_each(|(i, page)| {
                    for later_page in line.split(",").into_iter().skip(i) {
                        match page_map.get(later_page) {
                            Some(later_pages_pre_pages) => {
                                // if our current page is in the page_map as a value for a page that
                                // comes after it in the update, our current page is out of order.
                                if later_pages_pre_pages.contains(&page) {
                                    valid = false;
                                    break;
                                }
                            }
                            _ => {}
                        }
                    }
                });

            if valid {
                valid_updates.push(line);
            }
        }
    }
    dbg!(&valid_updates);
    valid_updates
        .into_iter()
        .fold(0, |sum, line| {
            let pages = line
                .split(",")
                .map(|page| page.parse::<i32>().unwrap())
                .collect::<Vec<i32>>();
            sum + pages[pages.len() / 2]
        })
        .to_string()
}

fn part2(input_string: &str) -> String {
    todo!("day05 part 2")
}

#[cfg(test)]
mod day05_tests {
    use std::io;

    use super::*;

    #[test]
    fn test_part1_example() -> io::Result<()> {
        let file = read_file("inputs/example".to_string());
        assert_eq!("143", run(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part1_input() -> io::Result<()> {
        let file = read_file("inputs/input".to_string());
        assert_eq!("4689", run(&file, 1).unwrap());
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
