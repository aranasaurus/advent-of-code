use itertools::Itertools;

pub fn part_one(input: &str) -> Option<u32> {
    let result = input
        .lines()
        .fold((0, 0), |(x, y), line| {
            let (cmd, v) = line
                .split_whitespace()
                .collect_tuple()
                .unwrap();
            let amount: isize = v.parse().unwrap();
            match cmd {
                "down" => (x, y + amount),
                "up" =>  (x, y - amount),
                "forward" => (x + amount, y),
                _ => (0, 0),
            }
        });

    Some(result.0 as u32 * result.1 as u32)
}

pub fn part_two(input: &str) -> Option<u32> {
    let result = input
        .lines()
        .fold((0, 0, 0), |(x, y, a), line| {
            let (cmd, v) = line
                .split_whitespace()
                .collect_tuple()
                .unwrap();
            let amount: isize = v.parse().unwrap();
            match cmd {
                "down" => (x, y, a + amount),
                "up" =>  (x, y, a - amount),
                "forward" => (
                    x + amount,
                    y + (a * amount),
                    a
                ),
                _ => (0, 0, 0),
            }
        });

    Some(result.0 as u32 * result.1 as u32)
}

fn main() {
    let input = &aoc::read_file("inputs", 2);
    aoc::solve!(1, part_one, input);
    aoc::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = aoc::read_file("examples", 2);
        assert_eq!(part_one(&input), Some(150));
    }

    #[test]
    fn test_part_two() {
        let input = aoc::read_file("examples", 2);
        assert_eq!(part_two(&input), Some(900));
    }
}
