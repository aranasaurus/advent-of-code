use itertools::Itertools;
use nom::{character::complete::line_ending, multi::separated_list1, IResult};

fn parse_numbers(input: &str) -> IResult<&str, Vec<(usize, i64)>> {
    let (input, v) = separated_list1(line_ending, nom::character::complete::i64)(input)?;
    Ok((input, v.into_iter().enumerate().collect_vec()))
}

fn coordinates(mixed: Vec<(usize, i64)>) -> Option<i64> {
    let mut result = vec![0i64; 3];
    if let Some(zero_i) = mixed.iter().position(|n| n.1 == 0) {
        result[0] = mixed[zero_i.wrapping_add(1000).rem_euclid(mixed.len())].1;
        result[1] = mixed[zero_i.wrapping_add(2000).rem_euclid(mixed.len())].1;
        result[2] = mixed[zero_i.wrapping_add(3000).rem_euclid(mixed.len())].1;
    }
    Some(result.iter().sum())
}

pub fn part_one(input: &str) -> Option<i64> {
    let (_, numbers) = parse_numbers(input).unwrap();

    let mut mixed = numbers.clone();
    for n in numbers {
        if let Some(i) = mixed.iter().position(|m| m.0 == n.0) {
            let removed = mixed.remove(i);
            let next_i = (i as i64 + removed.1).rem_euclid(mixed.len() as i64);
            mixed.insert(next_i as usize, removed);
        }
    }

    coordinates(mixed)
}

pub fn part_two(input: &str) -> Option<i64> {
    let (_, mut numbers) = parse_numbers(input).unwrap();
    numbers.iter_mut().for_each(|n| n.1 *= 811589153);

    let mut mixed = numbers.clone();
    for _ in 0..10 {
        for n in numbers.iter() {
            if let Some(i) = mixed.iter().position(|m| m.0 == n.0) {
                let removed = mixed.remove(i);
                let next_i = (i as i64 + removed.1).rem_euclid(mixed.len() as i64);
                mixed.insert(next_i as usize, removed);
            }
        }
    }

    coordinates(mixed)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 20);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 20);
        assert_eq!(part_one(&input), Some(3));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 20);
        assert_eq!(part_two(&input), Some(1623178306));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 20);
        assert_eq!(part_one(&input), Some(8028));
        assert_eq!(part_two(&input), Some(8798438007673));
    }
}
