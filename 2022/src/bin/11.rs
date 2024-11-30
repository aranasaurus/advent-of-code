use std::collections::VecDeque;

use itertools::Itertools;
use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{digit1, line_ending, multispace1, newline, space1},
    combinator::opt,
    multi::separated_list1,
    sequence::separated_pair,
    IResult,
};

#[derive(Debug, Clone)]
struct Monkey {
    items: VecDeque<u64>,
    inspections: u64,
    operation: Operation,
    divisible_by: u64,
    true_target: usize,
    false_target: usize,
}

impl Monkey {
    fn inspect(&mut self, reduce_worry: bool, lcm: u64) -> (usize, u64) {
        let item = self.items.pop_front().unwrap() % lcm;
        let mut worry = match self.operation {
            Operation::Multiply(value) => item * value,
            Operation::Add(value) => item + value,
            Operation::Square => item * item,
        };

        if reduce_worry {
            worry /= 3;
        }

        self.inspections += 1;

        let result = worry % self.divisible_by == 0;
        (
            if result {
                self.true_target
            } else {
                self.false_target
            },
            worry,
        )
    }
}

#[derive(Debug, Clone)]
enum Operation {
    Multiply(u64),
    Add(u64),
    Square,
}

fn parse_monkey(input: &str) -> IResult<&str, Monkey> {
    let (input, _) = separated_pair(tag("Monkey"), space1, digit1)(input)?;
    let (input, _) = tag(":")(input)?;
    let (input, _) = multispace1(input)?;

    // Items
    let (input, (_, items)) = separated_pair(
        tag("Starting items:"),
        space1,
        separated_list1(tag(", "), nom::character::complete::u64),
    )(input)?;

    // Operation
    let (input, _) = multispace1(input)?;
    let (input, _) = tag("Operation: new = old ")(input)?;
    let (input, op) = nom::combinator::map(
        separated_pair(alt((tag("*"), tag("+"))), space1, alt((tag("old"), digit1))),
        |(op_str, value)| match op_str {
            "*" => {
                if let Ok(value) = value.parse() {
                    Operation::Multiply(value)
                } else {
                    Operation::Square
                }
            }
            "+" => Operation::Add(value.parse().unwrap()),
            _ => panic!("Malformed operation"),
        },
    )(input)?;

    // Test
    let (input, _) = multispace1(input)?;
    let (input, _) = tag("Test: divisible by ")(input)?;
    let (input, divisor) = nom::character::complete::u64(input)?;
    let (input, _) = multispace1(input)?;
    let (input, _) = tag("If true: throw to monkey ")(input)?;
    let (input, true_monkey) =
        nom::combinator::map(nom::character::complete::u64, |i| i as usize)(input)?;
    let (input, _) = multispace1(input)?;
    let (input, _) = tag("If false: throw to monkey ")(input)?;
    let (input, false_monkey) =
        nom::combinator::map(nom::character::complete::u64, |i| i as usize)(input)?;

    // Eat the line_ending if it's there
    let (input, _) = opt(line_ending)(input)?;
    Ok((
        input,
        Monkey {
            items: VecDeque::from(items),
            inspections: 0,
            operation: op,
            divisible_by: divisor,
            true_target: true_monkey,
            false_target: false_monkey,
        },
    ))
}

pub fn part_one(input: &str) -> Option<u64> {
    let (_, mut monkeys) = separated_list1(newline, parse_monkey)(input).unwrap();
    let lcm: u64 = monkeys.iter().map(|m| m.divisible_by).product();
    for _ in 0..20 {
        for i in 0..monkeys.len() {
            for _ in 0..monkeys[i].items.len() {
                let monkey = monkeys.get_mut(i).unwrap();
                let (target_index, item) = monkey.inspect(true, lcm);
                monkeys.get_mut(target_index).unwrap().items.push_back(item);
            }
        }
    }
    Some(
        monkeys
            .iter()
            .map(|m| m.inspections)
            .sorted()
            .rev()
            .collect_vec()[..=1]
            .iter()
            .product(),
    )
}

pub fn part_two(input: &str) -> Option<u64> {
    let (_, mut monkeys) = separated_list1(newline, parse_monkey)(input).unwrap();
    let lcm: u64 = monkeys.iter().map(|m| m.divisible_by).product();
    for _ in 0..10000 {
        for i in 0..monkeys.len() {
            for _ in 0..monkeys[i].items.len() {
                let monkey = monkeys.get_mut(i).unwrap();
                let (target_index, item) = monkey.inspect(false, lcm);
                monkeys.get_mut(target_index).unwrap().items.push_back(item);
            }
        }
    }
    Some(
        monkeys
            .iter()
            .map(|m| m.inspections)
            .sorted()
            .rev()
            .collect_vec()[..=1]
            .iter()
            .product(),
    )
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 11);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 11);
        assert_eq!(part_one(&input), Some(10605));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 11);
        assert_eq!(part_two(&input), Some(2713310158));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 11);
        assert_eq!(part_one(&input), Some(56350));
        assert_eq!(part_two(&input), Some(13954061248));
    }

    #[test]
    fn test_inspect() {
        let mut m1 = Monkey {
            items: VecDeque::from([3]),
            inspections: 0,
            operation: Operation::Add(6),
            divisible_by: 3,
            true_target: 2,
            false_target: 1,
        };

        assert_eq!(m1.inspect(true, 3000), (2, 3));
        assert_eq!(m1.inspections, 1);
        assert_eq!(m1.items.is_empty(), true);

        m1.items.push_front(7);
        assert_eq!(m1.inspect(true, 3000), (1, 4));
        assert_eq!(m1.inspections, 2);
        assert_eq!(m1.items.is_empty(), true);
    }
}
