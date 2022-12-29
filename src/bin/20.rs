use itertools::Itertools;
use nom::{character::complete::line_ending, multi::separated_list1, IResult};

fn parse_numbers(input: &str) -> IResult<&str, Vec<(usize, i64)>> {
    let (input, v) = separated_list1(line_ending, nom::character::complete::i64)(input)?;
    Ok((input, v.into_iter().enumerate().collect_vec()))
}

pub fn part_one(input: &str) -> Option<i64> {
    let (_, numbers) = parse_numbers(input).unwrap();
    // dbg!(&numbers);
    let mut mixed = numbers.clone();

    for n in numbers {
        if let Some(i) = mixed.iter().position(|m| m.0 == n.0) {
            // dbg!(n);
            mixed.remove(i);
            let (next_i, overflowed) = i.overflowing_add_signed(n.1 as isize);
            let next_i = if overflowed {
                let overflow_amount = usize::MAX - next_i;
                if n.1.is_negative() {
                    // mixed.len() - overflow_amount - 1
                    if let Some(diff) = mixed.len().checked_sub(overflow_amount) {
                        diff - 1
                    } else {
                        mixed.len() - overflow_amount.rem_euclid(mixed.len()) - 1
                    }
                } else {
                    overflow_amount - 1
                }
            } else {
                next_i.rem_euclid(mixed.len())
            };
            mixed.insert(next_i, n);
            // dbg!(&mixed);
        }
    }

    let mut result = vec![0i64; 3];
    if let Some(zero_i) = mixed.iter().position(|n| n.1 == 0) {
        result[0] = mixed[zero_i.wrapping_add(1000).rem_euclid(mixed.len())].1;
        result[1] = mixed[zero_i.wrapping_add(2000).rem_euclid(mixed.len())].1;
        result[2] = mixed[zero_i.wrapping_add(3000).rem_euclid(mixed.len())].1;
    }
    Some(result.iter().sum())
}

pub fn part_two(_input: &str) -> Option<u32> {
    None
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
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 20);
        assert_eq!(part_one(&input), Some(8028));
        assert_eq!(part_two(&input), None);
    }
}
