use std::collections::HashSet;

use nom::{
    bytes::complete::tag, character::complete::line_ending, multi::separated_list1,
    sequence::tuple, IResult,
};

type Int = u16;
type Point = (Int, Int, Int);

fn parse_point(input: &str) -> IResult<&str, Point> {
    let (input, (x, _, y, _, z)) = tuple((
        nom::character::complete::u16,
        tag(","),
        nom::character::complete::u16,
        tag(","),
        nom::character::complete::u16,
    ))(input)?;

    Ok((input, (x, y, z)))
}

fn surrounding_points(point: &Point) -> HashSet<Point> {
    let mut points = HashSet::new();
    // right
    points.insert((point.0 + 1, point.1, point.2));
    // left
    if point.0 > 0 {
        points.insert((point.0 - 1, point.1, point.2));
    }

    // above
    points.insert((point.0, point.1 + 1, point.2));
    // below
    if point.1 > 0 {
        points.insert((point.0, point.1 - 1, point.2));
    }

    // back
    points.insert((point.0, point.1, point.2 + 1));
    // front
    if point.2 > 0 {
        points.insert((point.0, point.1, point.2 - 1));
    }

    points
}

pub fn part_one(input: &str) -> Option<u32> {
    let (_, points_list) = separated_list1(line_ending, parse_point)(input).unwrap();
    let points: HashSet<Point> = HashSet::from_iter(points_list.iter().cloned());

    let result = points.iter().fold(points.len() * 6, |acc, point| {
        let adjacent = surrounding_points(point);
        let existing = adjacent.difference(&points).count();
        let mut edges = 0;
        if point.0 == 0 {
            edges += 1;
        }
        if point.1 == 0 {
            edges += 1;
        }
        if point.2 == 0 {
            edges += 1;
        }
        acc - (6 - existing) + edges
    });

    Some(result as u32)
}

pub fn part_two(_input: &str) -> Option<u32> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 18);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_two_cubes() {
        let input = "1,1,1
2,1,1
";
        assert_eq!(part_one(&input), Some(10));
    }

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 18);
        assert_eq!(part_one(&input), Some(64));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 18);
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 18);
        assert_eq!(part_one(&input), Some(4244));
        assert_eq!(part_two(&input), None);
    }
}
