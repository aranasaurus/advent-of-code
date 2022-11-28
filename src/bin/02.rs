use itertools::Itertools;

pub fn part_one(input: &str) -> Option<u32> {
    let result = input
        .lines()
        .map(|line| {
            let (dir, n) = line
                .split_whitespace()
                .collect_tuple()
                .unwrap();
            let distance: isize = n.parse().unwrap();
            match dir {
                "forward" => (distance, 0),
                "up" =>  (0, -distance),
                "down" => (0, distance),
                _ => (0, 0),
            }
        })
        .fold((0, 0), |(h, v), (hi, vi)| (h + hi, v + vi) );

    Some(result.0 as u32 * result.1 as u32)
}

pub fn part_two(input: &str) -> Option<u32> {
    None
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
        assert_eq!(part_two(&input), None);
    }
}
