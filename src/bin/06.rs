use std::collections::BTreeSet;

pub fn part_one(input: &str) -> Option<u32> {
    let chars = input.chars().collect::<Vec<char>>();
    let signal = chars
        .windows(4)
        .enumerate()
        .find(|(_, slice)| {
            let set = slice.iter().collect::<BTreeSet<&char>>();
            slice.len() == set.len()
        })
        .unwrap();
    Some(signal.0 as u32 + 4)
}

pub fn part_two(input: &str) -> Option<u32> {
    let chars = input.chars().collect::<Vec<char>>();
    let signal = chars
        .windows(14)
        .enumerate()
        .find(|(_, slice)| {
            let set = slice.iter().collect::<BTreeSet<&char>>();
            slice.len() == set.len()
        })
        .unwrap();
    Some(signal.0 as u32 + 14)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 6);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        assert_eq!(part_one("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), Some(7));
        assert_eq!(part_one("bvwbjplbgvbhsrlpgdmjqwftvncz"), Some(5));
        assert_eq!(part_one("nppdvjthqldpwncqszvftbrmjlhg"), Some(6));
        assert_eq!(part_one("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), Some(10));
        assert_eq!(part_one("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), Some(11));
    }

    #[test]
    fn test_part_two() {
        assert_eq!(part_two("mjqjpqmgbljsphdztnvjfqwrcgsmlb"), Some(19));
        assert_eq!(part_two("bvwbjplbgvbhsrlpgdmjqwftvncz"), Some(23));
        assert_eq!(part_two("nppdvjthqldpwncqszvftbrmjlhg"), Some(23));
        assert_eq!(part_two("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"), Some(29));
        assert_eq!(part_two("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"), Some(26));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 6);
        assert_eq!(part_one(&input), Some(1794));
        assert_eq!(part_two(&input), Some(2851));
    }
}
