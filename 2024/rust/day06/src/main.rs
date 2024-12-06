use std::{collections::HashMap, fs};

use clap::Parser;
use glam::IVec2;

fn run(input_string: &str, part: u8) -> Result<String, Error> {
    match part {
        1 => Ok(part1(&input_string)),
        2 => Ok(part2(&input_string)),
        _ => Err(Error::InvalidPart),
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Entity {
    Obstacle,
    Visited,
    Exit,
}

fn part1(input_string: &str) -> String {
    let mut width = 0i32;
    let mut map = HashMap::new();
    let mut guard_pos = IVec2::splat(-1);
    for (y, line) in input_string.lines().into_iter().enumerate() {
        if y == 0 {
            width = line.len() as i32;
        }

        // Add exits on either end of the row
        map.insert(IVec2::new(-1, y as i32), Entity::Exit);
        map.insert(IVec2::new(width, y as i32), Entity::Exit);
        for (x, c) in line.chars().enumerate() {
            let pos = IVec2::new(x as i32, y as i32);
            match c {
                '#' => {
                    map.insert(pos, Entity::Obstacle);
                }
                '^' => {
                    guard_pos = pos;
                    map.insert(pos, Entity::Visited);
                }
                _ => {}
            };
        }
    }
    // Add row of exits to top and bottom.
    for x in -1..=width {
        map.insert(IVec2::new(x as i32, -1), Entity::Exit);
        map.insert(
            IVec2::new(x as i32, input_string.lines().count() as i32),
            Entity::Exit,
        );
    }

    let mut dir = IVec2::new(0, -1);
    let mut next_pos = guard_pos + dir;
    loop {
        let next = map.get(&next_pos);
        match next {
            Some(Entity::Exit) => break, // all done
            Some(Entity::Obstacle) => {
                // next_pos is at the obstacle, so we need to bring it back to where it was, then
                // rotate the dir before applying it.
                next_pos -= dir;
                dir = dir.perp();
            }
            Some(Entity::Visited) => {} // no op
            None => {
                // Nothing here, so it's a newly visited space.
                map.insert(next_pos, Entity::Visited);
            }
        };
        next_pos += dir;
    }

    // print_map(&map, width);
    map.values()
        .filter(|&&v| v == Entity::Visited)
        .count()
        .to_string()
}

#[allow(dead_code)]
fn print_map(map: &HashMap<IVec2, Entity>, width: i32) {
    let mut s = "\n".to_string();
    for y in 0..width {
        for x in 0..width {
            s.push(match map.get(&IVec2::new(x, y)) {
                Some(Entity::Obstacle) => '#',
                Some(Entity::Exit) => '0',
                Some(Entity::Visited) => 'X',
                None => '.',
            })
        }
        s.push('\n');
    }
    println!("{s}");
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
        assert_eq!("41", run(&file, 1).unwrap());
        Ok(())
    }

    #[test]
    fn test_part1_input() -> io::Result<()> {
        let file = read_file("inputs/input".to_string());
        assert_eq!("4964", run(&file, 1).unwrap());
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
