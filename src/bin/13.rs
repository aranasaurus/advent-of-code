use std::cmp;

use itertools::Itertools;
use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::newline,
    combinator::map,
    multi::{separated_list0, separated_list1},
    sequence::{delimited, separated_pair},
    IResult, Parser,
};

#[derive(Debug)]
struct Pair {
    left: Packet,
    right: Packet,
}

impl Pair {
    fn is_correct_order(&self) -> bool {
        match self.left.cmp(&self.right) {
            cmp::Ordering::Less => true,
            cmp::Ordering::Equal => todo!(),
            cmp::Ordering::Greater => false,
        }
    }
}

#[derive(Debug, Eq)]
enum Packet {
    Number(u32),
    List(Vec<Packet>),
}

impl PartialEq for Packet {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Packet::Number(n1), Packet::Number(n2)) => n1 == n2,
            (Packet::Number(n), Packet::List(l)) => &vec![Packet::Number(*n)] == l,
            (Packet::List(l), Packet::Number(n)) => &vec![Packet::Number(*n)] == l,
            (Packet::List(l1), Packet::List(l2)) => l1 == l2,
        }
    }
}

impl Ord for Packet {
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        match (self, other) {
            (Packet::Number(n1), Packet::Number(n2)) => n1.cmp(n2),
            (Packet::Number(n), Packet::List(l)) => vec![Packet::Number(*n)].cmp(l),
            (Packet::List(l), Packet::Number(n)) => l.cmp(&vec![Packet::Number(*n)]),
            (Packet::List(l1), Packet::List(l2)) => l1.cmp(l2),
        }
    }
}

impl PartialOrd for Packet {
    fn partial_cmp(&self, other: &Self) -> Option<cmp::Ordering> {
        Some(self.cmp(other))
    }
}

fn packet(input: &str) -> IResult<&str, Packet> {
    alt((
        delimited(tag("["), separated_list0(tag(","), packet), tag("]")).map(Packet::List),
        nom::character::complete::u32.map(Packet::Number),
    ))(input)
}

fn pair(input: &str) -> IResult<&str, Pair> {
    map(separated_pair(packet, newline, packet), |(left, right)| {
        Pair { left, right }
    })(input)
}

pub fn part_one(input: &str) -> Option<u32> {
    let (_, pairs) = separated_list1(tag("\n\n"), pair)(input).unwrap();
    let result = pairs
        .iter()
        .enumerate()
        .filter_map(|(i, pair)| {
            if pair.is_correct_order() {
                Some(i as u32 + 1)
            } else {
                None
            }
        })
        .sum();
    Some(result)
}

pub fn part_two(input: &str) -> Option<u32> {
    let (_, pairs) = separated_list1(tag("\n\n"), pair)(input).unwrap();
    let mut packets = pairs
        .into_iter()
        .flat_map(|pair| [pair.left, pair.right])
        .collect_vec();

    packets.push(Packet::List(vec![Packet::List(vec![Packet::Number(2)])]));
    packets.push(Packet::List(vec![Packet::List(vec![Packet::Number(6)])]));
    packets.sort();
    let div1_index = packets
        .binary_search(&Packet::List(vec![Packet::Number(2)]))
        .unwrap() as u32
        + 1;
    let div2_index = packets
        .binary_search(&Packet::List(vec![Packet::Number(6)]))
        .unwrap() as u32
        + 1;
    Some(div1_index * div2_index)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 13);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 13);
        assert_eq!(part_one(&input), Some(13));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 13);
        assert_eq!(part_two(&input), Some(140));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 13);
        assert_eq!(part_one(&input), Some(6235));
        assert_eq!(part_two(&input), Some(22866));
    }
}
