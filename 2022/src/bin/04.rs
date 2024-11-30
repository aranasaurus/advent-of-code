use itertools::Itertools;

pub fn part_one(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .filter(|line| {
                let (left, right) = parse_ranges(line);

                (right.contains(left.start()) && right.contains(left.end()))
                    || (left.contains(right.start()) && left.contains(right.end()))
            })
            .count() as u32,
    )
}

pub fn part_two(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .filter(|line| {
                let (left, right) = parse_ranges(line);

                right.contains(left.start())
                    || right.contains(left.end())
                    || left.contains(right.start())
                    || left.contains(right.end())
            })
            .count() as u32,
    )
}

fn parse_ranges(line: &&str) -> (std::ops::RangeInclusive<u32>, std::ops::RangeInclusive<u32>) {
    let (left, right) = line.split_once(',').unwrap();

    let (left_start, left_end) = parse_range(left);
    let (right_start, right_end) = parse_range(right);

    (left_start..=left_end, right_start..=right_end)
}

fn parse_range(range: &str) -> (u32, u32) {
    let (start, end) = range
        .split_terminator('-')
        .map(|item| item.parse::<u32>().unwrap())
        .collect_tuple()
        .unwrap();
    (start, end)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 4);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 4);
        assert_eq!(part_one(&input), Some(2));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 4);
        assert_eq!(part_two(&input), Some(4));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 4);
        assert_eq!(part_one(&input), Some(450));
        assert_eq!(part_two(&input), Some(837));
    }
}
