use std::{collections::HashSet, ops::RangeInclusive};

use itertools::Itertools;
use nom::{
    bytes::complete::tag, character::complete::line_ending, multi::separated_list1,
    sequence::separated_pair, IResult,
};

// TODO: Performance optimizations 😬

type Int = i32;
type Point = (Int, Int);

#[derive(Debug)]
struct Sensor {
    location: Point,
    beacon_location: Point,
    beacon_distance: Int,
}

impl Sensor {
    fn covered_xrange(&self, y: Int) -> Option<RangeInclusive<Int>> {
        let y_dist = self.location.1.abs_diff(y) as Int;
        if y_dist > self.beacon_distance {
            return None;
        }

        let x_dist = self.beacon_distance - y_dist;
        let x_start = self.location.0 - x_dist;
        let x_end = self.location.0 + x_dist;
        Some(x_start..=x_end)
    }
}

fn point(input: &str) -> IResult<&str, Point> {
    let (input, (_, x)) = separated_pair(tag("x"), tag("="), nom::character::complete::i32)(input)?;
    let (input, _) = tag(", ")(input)?;
    let (input, (_, y)) = separated_pair(tag("y"), tag("="), nom::character::complete::i32)(input)?;
    Ok((input, (x, y)))
}

fn sensor(input: &str) -> IResult<&str, Sensor> {
    let (input, _) = tag("Sensor at ")(input)?;
    let (input, location) = point(input)?;
    let (input, _) = tag(": closest beacon is at ")(input)?;
    let (input, beacon_location) = point(input)?;

    let beacon_distance = location.0.abs_diff(beacon_location.0) as Int
        + location.1.abs_diff(beacon_location.1) as Int;

    Ok((
        input,
        Sensor {
            location,
            beacon_location,
            beacon_distance,
        },
    ))
}

fn _part_one(input: &str, y: Int) -> Option<u32> {
    let (_, sensors) = separated_list1(line_ending, sensor)(input).unwrap();
    let result: HashSet<Int> = sensors
        .iter()
        .filter_map(|s| {
            if let Some(r) = s.covered_xrange(y) {
                let r = *r.start()..*r.end() + 1;
                Some(
                    if s.beacon_location.1 == y && r.contains(&s.beacon_location.0) {
                        r.filter(|&x| x != s.beacon_location.0).collect_vec()
                    } else {
                        r.collect_vec()
                    },
                )
            } else {
                None
            }
        })
        .flatten()
        .collect();
    Some(result.len() as u32)
}

pub fn part_one(input: &str) -> Option<u32> {
    _part_one(input, 2000000)
}

pub fn part_two(input: &str) -> Option<u32> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 15);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_covered_xrange() {
        let s = Sensor {
            location: (0, 0),
            beacon_distance: 5,
            beacon_location: (2, 3),
        };
        assert_eq!(s.covered_xrange(0), Some(-5..=5));
        assert_eq!(s.covered_xrange(5), Some(0..=0));
        assert_eq!(s.covered_xrange(-2), Some(-3..=3));
        assert_eq!(s.covered_xrange(2), Some(-3..=3));

        assert_eq!(s.covered_xrange(6), None);
        assert_eq!(s.covered_xrange(-6), None);
        assert_eq!(s.covered_xrange(600), None);
        assert_eq!(s.covered_xrange(-600), None);
    }

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 15);
        assert_eq!(_part_one(&input, 10), Some(26));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 15);
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 15);
        assert_eq!(part_one(&input), Some(5335787));
        assert_eq!(part_two(&input), None);
    }
}
