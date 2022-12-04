use itertools::Itertools;

pub fn part_one(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .filter(|line| {
                let (left, right) = line.split_once(',').unwrap();
                let (left_start, left_end) = left
                    .split_terminator('-')
                    .map(|item| item.parse::<u32>().unwrap())
                    .collect_tuple()
                    .unwrap();
                let (right_start, right_end) = right
                    .split_terminator('-')
                    .map(|item| item.parse::<u32>().unwrap())
                    .collect_tuple()
                    .unwrap();

                let left_range = left_start..=left_end;
                let right_range = right_start..=right_end;

                (right_range.contains(&left_start) && right_range.contains(&left_end))
                    || (left_range.contains(&right_start) && left_range.contains(&right_end))
            })
            .count() as u32,
    )
}

pub fn part_two(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .filter(|line| {
                let (left, right) = line.split_once(',').unwrap();
                let (left_start, left_end) = left
                    .split_terminator('-')
                    .map(|item| item.parse::<u32>().unwrap())
                    .collect_tuple()
                    .unwrap();
                let (right_start, right_end) = right
                    .split_terminator('-')
                    .map(|item| item.parse::<u32>().unwrap())
                    .collect_tuple()
                    .unwrap();

                let left_range = left_start..=left_end;
                let right_range = right_start..=right_end;

                right_range.contains(&left_start)
                    || right_range.contains(&left_end)
                    || left_range.contains(&right_start)
                    || left_range.contains(&right_end)
            })
            .count() as u32,
    )
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
