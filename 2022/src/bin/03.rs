use itertools::Itertools;

fn priority(item: char) -> u8 {
    if item.is_ascii_lowercase() {
        1 + item as u8 - b'a'
    } else {
        27 + item as u8 - b'A'
    }
}

pub fn part_one(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .map(|line| {
                let (left, right) = line.split_at(line.len() / 2);
                let common = left.chars().find(|c| right.contains(*c)).unwrap();
                priority(common) as u32
            })
            .sum(),
    )
}

pub fn part_two(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .tuples()
            .map(|(first, second, third)| {
                let common = first
                    .chars()
                    .find(|c| second.contains(*c) && third.contains(*c))
                    .unwrap();
                priority(common) as u32
            })
            .sum(),
    )
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 3);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 3);
        assert_eq!(part_one(&input), Some(157));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 3);
        assert_eq!(part_two(&input), Some(70));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 3);
        assert_eq!(part_one(&input), Some(7446));
        assert_eq!(part_two(&input), Some(2646));
    }
}
