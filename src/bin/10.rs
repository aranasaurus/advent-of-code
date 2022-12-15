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

pub fn part_one(input: &str) -> Option<i32> {
    let (_, operations) = separated_list1(newline, parse_operation)(input).unwrap();
    let mut x = 1;
    let mut x_history = vec![x];

    for op in operations {
        match op {
            Operation::Add(value) => {
                x_history.push(x);
                x_history.push(x);
                x += value;
            }
            Operation::Noop => {
                x_history.push(x);
            }
        }
    }

    let interesting_cycles = vec![20_usize, 60, 100, 140, 180, 220];

    let sum: i32 = interesting_cycles
        .iter()
        .filter(|&&c| c < x_history.len())
        .map(|&c| -> i32 {
            let x = x_history[c];
            x * c as i32
        })
        .sum();

    Some(sum)
}

pub fn part_two(input: &str) -> Option<u32> {
    None
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
        let input = "addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1";
        assert_eq!(part_one(&input), Some(420));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 10);
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 10);
        assert_eq!(part_one(&input), Some(14360));
        assert_eq!(part_two(&input), None);
    }
}
