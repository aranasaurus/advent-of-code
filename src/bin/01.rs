use itertools::Itertools;

pub fn part_one(input: &str) -> Option<u32> {
    let result = input
        .lines()
        .map(|line| { line.parse::<u16>().unwrap() })
        .tuple_windows()
        .filter(|(a, b)| a < b )
        .count();
    
    Some(result as u32)
}

pub fn part_two(input: &str) -> Option<u32> {
    let result = input
        .lines()
        .map(|line| { line.parse::<u16>().unwrap() })
        .tuple_windows()
        .filter(|(a, _, _, b)| a < b )
        .count();
    
    Some(result as u32)
}

fn main() {
    let input = &aoc::read_file("inputs", 1);
    aoc::solve!(1, part_one, input);
    aoc::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = aoc::read_file("examples", 1);
        assert_eq!(part_one(&input), Some(7));
    }

    #[test]
    fn test_part_two() {
        let input = aoc::read_file("examples", 1);
        assert_eq!(part_two(&input), Some(5));
    }
}
