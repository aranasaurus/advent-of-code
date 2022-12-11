use std::collections::HashSet;

use nom::{
    character::complete::{alpha1, digit1, newline, space1},
    combinator::map,
    multi::separated_list1,
    sequence::separated_pair,
    IResult,
};

#[derive(Copy, Clone, Debug)]
enum Move {
    Up(u16),
    Down(u16),
    Left(u16),
    Right(u16),
}

impl Move {
    fn amount(self: Move) -> u16 {
        match self {
            Move::Up(amount) => amount,
            Move::Down(amount) => amount,
            Move::Left(amount) => amount,
            Move::Right(amount) => amount,
        }
    }
}

#[derive(Copy, Clone, Debug, Eq, Hash, PartialEq)]
struct Vector2D {
    x: i16,
    y: i16,
}

impl Vector2D {
    fn distance_to(self: Vector2D, other: Vector2D) -> Vector2D {
        Vector2D {
            x: self.x.abs_diff(other.x) as i16,
            y: self.y.abs_diff(other.y) as i16,
        }
    }

    fn move_one(self: &mut Vector2D, m: Move) {
        match m {
            Move::Up(_) => self.y += 1,
            Move::Down(_) => self.y -= 1,
            Move::Left(_) => self.x -= 1,
            Move::Right(_) => self.x += 1,
        }
    }
}

fn parse_move(input: &str) -> IResult<&str, Move> {
    map(
        separated_pair(alpha1, space1, digit1),
        |(m, amount): (&str, &str)| {
            let amount = amount.parse::<u16>().unwrap();
            match m {
                "U" => Move::Up(amount),
                "D" => Move::Down(amount),
                "L" => Move::Left(amount),
                "R" => Move::Right(amount),
                _ => panic!("Unknown move type {}", m),
            }
        },
    )(input)
}

pub fn part_one(input: &str) -> Option<u32> {
    let (_, moves) = separated_list1(newline, parse_move)(input).unwrap();

    let mut visited = HashSet::<Vector2D>::new();
    let mut head = Vector2D { x: 0, y: 0 };
    let mut tail = Vector2D { x: 0, y: 0 };

    visited.insert(tail);

    // TODO: There's probably some math trick here to speed this up, but I sure don't know it.
    // I feel like Verlet Integration could work, but I'm struggling to figure out how to apply it here.
    for m in moves {
        for _ in 0..m.amount() {
            head.move_one(m);

            let d = tail.distance_to(head);

            if d.x > 1 || (d.x == 1 && d.y > 1) {
                if head.x > tail.x {
                    tail.x += 1;
                } else {
                    tail.x -= 1;
                }
            }

            if d.y > 1 || (d.y == 1 && d.x > 1) {
                if head.y > tail.y {
                    tail.y += 1;
                } else {
                    tail.y -= 1;
                }
            }

            visited.insert(tail);
        }
    }
    Some(visited.len() as u32)
}

pub fn part_two(input: &str) -> Option<u32> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 9);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 9);
        assert_eq!(part_one(&input), Some(13));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 9);
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 9);
        assert_eq!(part_one(&input), Some(6367));
        assert_eq!(part_two(&input), None);
    }
}
