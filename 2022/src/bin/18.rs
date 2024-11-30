use std::collections::{HashSet, VecDeque};

use nom::{
    bytes::complete::tag, character::complete::line_ending, multi::separated_list1,
    sequence::tuple, IResult,
};

type Int = i16;
type Point = (Int, Int, Int);

fn parse_point(input: &str) -> IResult<&str, Point> {
    let (input, (x, _, y, _, z)) = tuple((
        nom::character::complete::i16,
        tag(","),
        nom::character::complete::i16,
        tag(","),
        nom::character::complete::i16,
    ))(input)?;

    Ok((input, (x, y, z)))
}

fn surrounding_points(point: &Point) -> HashSet<Point> {
    let mut points = HashSet::new();
    // right
    points.insert((point.0 + 1, point.1, point.2));
    // left
    points.insert((point.0 - 1, point.1, point.2));

    // above
    points.insert((point.0, point.1 + 1, point.2));
    // below
    points.insert((point.0, point.1 - 1, point.2));

    // back
    points.insert((point.0, point.1, point.2 + 1));
    // front
    points.insert((point.0, point.1, point.2 - 1));

    points
}

pub fn part_one(input: &str) -> Option<u32> {
    let (_, points_list) = separated_list1(line_ending, parse_point)(input).unwrap();
    let points: HashSet<Point> = HashSet::from_iter(points_list.iter().cloned());

    let result = points.iter().fold(points.len() * 6, |acc, point| {
        let adjacent = surrounding_points(point);
        let existing = adjacent.difference(&points).count();
        acc - (6 - existing)
    });

    Some(result as u32)
}

pub fn part_two(input: &str) -> Option<u32> {
    let (_, points_list) = separated_list1(line_ending, parse_point)(input).unwrap();

    let points: HashSet<Point> = HashSet::from_iter(points_list.iter().cloned());

    let max_x = points.iter().map(|p| p.0).max().unwrap();
    let max_y = points.iter().map(|p| p.1).max().unwrap();
    let max_z = points.iter().map(|p| p.2).max().unwrap();
    let min_x = points.iter().map(|p| p.0).min().unwrap();
    let min_y = points.iter().map(|p| p.1).min().unwrap();
    let min_z = points.iter().map(|p| p.2).min().unwrap();
    let x_range = min_x - 1..=max_x + 1;
    let y_range = min_y - 1..=max_y + 1;
    let z_range = min_z - 1..=max_z + 1;

    let mut seen = HashSet::new();
    let mut to_see = VecDeque::new();
    to_see.push_back((*x_range.start(), *y_range.start(), *z_range.start()));

    let mut sides = 0;
    while let Some(coord) = to_see.pop_front() {
        if !seen.insert(coord) {
            continue;
        }

        let adjacents = surrounding_points(&coord);
        for adjacent in adjacents {
            if !x_range.contains(&adjacent.0)
                || !y_range.contains(&adjacent.1)
                || !z_range.contains(&adjacent.2)
            {
                continue;
            }

            if points.contains(&adjacent) {
                sides += 1;
            } else {
                to_see.push_back(adjacent);
            }
        }
    }

    Some(sides as u32)
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
        assert_eq!(part_two(&input), Some(58));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 18);
        assert_eq!(part_one(&input), Some(4244));
        assert_eq!(part_two(&input), Some(2460));
    }
}
