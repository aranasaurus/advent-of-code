use std::{collections::HashMap, fmt::Display};

use nom::{
    bytes::complete::tag, character::complete::newline, multi::separated_list1,
    sequence::separated_pair, IResult,
};

// TODO: This one would be fun to visualize as an animation, I think.
// TODO: Part 2 of this is currently the slowest solution I've got, so there are performance
//   optimization opportunities here. I think the Map's grid implementation is probably the
//   culprit.

type Point = (u32, u32);

fn parse_line(input: &str) -> IResult<&str, Vec<Point>> {
    separated_list1(
        tag(" -> "),
        separated_pair(
            nom::character::complete::u32,
            tag(","),
            nom::character::complete::u32,
        ),
    )(input)
}

#[derive(Debug, PartialEq)]
enum Block {
    Rock,
    Sand,
    Start,
}

#[derive(Debug)]
struct Map {
    grid: HashMap<Point, Block>,
    start: Point,
    min_x: u32,
    min_y: u32,
    max_x: u32,
    max_y: u32,
}

impl Map {
    fn new(shapes: Vec<Vec<Point>>, start: Point, has_floor: bool) -> Self {
        let mut grid = HashMap::new();
        grid.insert(start, Block::Start);

        let mut min_x = start.0;
        let mut max_x = start.0;
        let mut min_y = start.1;
        let mut max_y = start.1;
        for shape in shapes {
            for (i, &point) in shape[..shape.len() - 1].iter().enumerate() {
                grid.insert(point, Block::Rock);
                let next = shape[i + 1];
                grid.insert(next, Block::Rock);

                if point.0 == next.0 {
                    let top = point.1.min(next.1);
                    let bottom = point.1.max(next.1);
                    for y in top..bottom {
                        grid.insert((point.0, y), Block::Rock);
                    }
                } else {
                    let left = point.0.min(next.0);
                    let right = point.0.max(next.0);
                    for x in left..right {
                        grid.insert((x, point.1), Block::Rock);
                    }
                }

                min_x = min_x.min(point.0.min(next.0));
                min_y = min_y.min(point.1.min(next.1));
                max_x = max_x.max(point.0.max(next.0));
                max_y = max_y.max(point.1.max(next.1));
            }
        }

        if has_floor {
            let height = max_y - min_y + 1;
            let add_to_sides = height - 1;
            min_x -= start.0 - add_to_sides;
            max_x += start.1 + add_to_sides;

            max_y += 2;
            for x in min_x..=max_x {
                grid.insert((x, max_y), Block::Rock);
            }
        }

        Self {
            grid,
            start,
            min_x,
            min_y,
            max_x,
            max_y,
        }
    }

    fn produce_sand(&mut self) -> Option<Point> {
        if let Some(s) = self.grid.get(&self.start) {
            if *s == Block::Sand {
                return None;
            }
        }

        let mut sand = self.start;
        let valid_ys = self.min_y..=self.max_y;
        while valid_ys.contains(&sand.1) {
            if let Some(new_pos) = self.advance_sand(&sand) {
                sand.0 = new_pos.0;
                sand.1 = new_pos.1;
            } else {
                self.grid.insert(sand, Block::Sand);
                return Some(sand);
            }
        }
        None
    }

    fn advance_sand(&self, sand: &Point) -> Option<Point> {
        let below = sand.1 + 1;
        let left = sand.0 - 1;
        let right = sand.0 + 1;
        if self.grid.get(&(sand.0, below)).is_some() {
            if self.grid.get(&(left, below)).is_some() {
                if self.grid.get(&(right, below)).is_some() {
                    None
                } else {
                    Some((right, below))
                }
            } else {
                Some((left, below))
            }
        } else {
            Some((sand.0, below))
        }
    }
}

impl Display for Map {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut chars = vec![];
        for y in self.min_y..=self.max_y {
            for x in self.min_x..=self.max_x {
                chars.push(if let Some(block) = self.grid.get(&(x, y)) {
                    match block {
                        Block::Rock => '#',
                        Block::Sand => 'o',
                        Block::Start => '+',
                    }
                } else {
                    '.'
                });
            }
            chars.push('\n');
        }
        write!(f, "{}", String::from_iter(chars))
    }
}

pub fn part_one(input: &str) -> Option<u32> {
    let (_, shapes) = separated_list1(newline, parse_line)(input).unwrap();
    let mut map = Map::new(shapes, (500, 0), false);
    // println!("{}", map);

    let mut sands = vec![];
    while let Some(sand) = map.produce_sand() {
        sands.push(sand);
    }
    // println!("{}", map);

    Some(sands.len() as u32)
}

pub fn part_two(input: &str) -> Option<u32> {
    let (_, shapes) = separated_list1(newline, parse_line)(input).unwrap();
    let mut map = Map::new(shapes, (500, 0), true);
    // println!("{}", map);

    let mut sands = vec![];
    while let Some(sand) = map.produce_sand() {
        sands.push(sand);
    }
    // println!("{}", map);

    Some(sands.len() as u32)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 14);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 14);
        assert_eq!(part_one(&input), Some(24));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 14);
        assert_eq!(part_two(&input), Some(93));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 14);
        assert_eq!(part_one(&input), Some(1078));
        assert_eq!(part_two(&input), Some(30157));
    }
}
