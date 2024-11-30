use itertools::Itertools;
use nom::{
    character::complete::{alpha1, newline, space1},
    error::ErrorKind,
    error_position,
    multi::separated_list1,
    Err, IResult,
};

#[derive(Debug)]
enum Operation {
    Add(i32),
    Noop,
}

fn parse_operation(input: &str) -> IResult<&str, Operation> {
    let (input, op) = alpha1(input)?;
    match op {
        "addx" => {
            let (input, _) = space1(input)?;
            let (input, value) = nom::character::complete::i32(input)?;
            Ok((input, Operation::Add(value)))
        }
        "noop" => Ok((input, Operation::Noop)),
        _ => Err(Err::Error(error_position!(
            "Unkown operation",
            ErrorKind::Fail
        ))),
    }
}

fn run(operations: Vec<Operation>) -> Vec<i32> {
    let mut x = 1;
    let mut x_history = vec![x];
    operations.into_iter().for_each(|op| match op {
        Operation::Add(value) => {
            x_history.push(x);
            x_history.push(x);
            x += value;
        }
        Operation::Noop => {
            x_history.push(x);
        }
    });
    x_history
}

pub fn part_one(input: &str) -> Option<i32> {
    let (_, operations) = separated_list1(newline, parse_operation)(input).unwrap();
    let x_history = run(operations);

    let interesting_cycles = vec![20_usize, 60, 100, 140, 180, 220];

    let sum: i32 = interesting_cycles
        .iter()
        .filter(|&&c| c < x_history.len()) // this is to support the test that only checks against the first 20 cycles
        .map(|&c| -> i32 {
            let x = x_history[c];
            x * c as i32
        })
        .sum();

    Some(sum)
}

pub fn part_two(input: &str) -> Option<String> {
    let (_, operations) = separated_list1(newline, parse_operation)(input).unwrap();
    let x_history = run(operations);

    let mut crt = vec!["."; 240];
    x_history
        .iter()
        .dropping(1)
        .enumerate()
        .for_each(|(pixel, &x)| {
            // crt is a 1d vec, storing all 6 rows of the display contiguously. Each row is 40 pixels.
            // So h_pos is what would be the x component of a pixel's coordinate if we were using cartesian coordinates.
            let h_pos = (pixel % 40) as i32;
            if h_pos.abs_diff(x) <= 1 {
                crt[pixel] = "#";
            }
        });

    crt.insert(40, "\n");
    crt.insert(81, "\n");
    crt.insert(122, "\n");
    crt.insert(163, "\n");
    crt.insert(204, "\n");

    let result = crt.concat();
    Some(result)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 10);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 10);
        assert_eq!(part_one(&input), Some(13140));
    }

    #[test]
    fn test_part_one_20() {
        let input = "
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1"
            .trim();
        assert_eq!(part_one(&input), Some(420));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 10);
        assert_eq!(
            part_two(&input),
            Some(
                "
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######....."
                    .trim()
                    .into()
            )
        );
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 10);
        assert_eq!(part_one(&input), Some(14360));
        assert_eq!(
            part_two(&input),
            Some(
                "
###...##..#..#..##..####.###..####.####.
#..#.#..#.#.#..#..#.#....#..#.#.......#.
###..#....##...#..#.###..#..#.###....#..
#..#.#.##.#.#..####.#....###..#.....#...
#..#.#..#.#.#..#..#.#....#.#..#....#....
###...###.#..#.#..#.####.#..#.####.####."
                    .trim()
                    .into()
            )
        );
    }
}
