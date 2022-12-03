fn priority(item: char) -> u8 {
    if item.is_ascii_lowercase() {
        1 + item as u8 - b'a'
    } else {
        27 + item as u8 - b'A'
    }
}

fn find_dup(sack: &str) -> char {
    let (left, right) = sack.split_at(sack.len() / 2);
    for l in left.chars() {
        for r in right.chars() {
            if l == r {
                return l;
            }
        }
    }

    panic!("No duplicate found")
}

pub fn part_one(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .map(|line| priority(find_dup(line)) as u32)
            .sum(),
    )
}

pub fn part_two(_input: &str) -> Option<u32> {
    None
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
    #[ignore]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 3);
        assert_eq!(part_two(&input), None);
    }
}
