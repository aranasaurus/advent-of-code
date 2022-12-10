use itertools::Itertools;

fn parse_heights(input: &str) -> Vec<Vec<u8>> {
    input
        .lines()
        .map(|line| {
            line.chars()
                .map(|c| c.to_digit(10).unwrap() as u8)
                .collect::<Vec<u8>>()
        })
        .collect::<Vec<Vec<u8>>>()
}

pub fn part_one(input: &str) -> Option<u32> {
    let heights = parse_heights(input);
    let h = heights.len();
    let w = heights[0].len();
    let mut visibilities = vec![vec![false; w]; h];

    for y in 0..heights.len() {
        for x in 0..heights[y].len() {
            let height = heights[y][x];

            // if it's an edge tree, or max height, it's automatically visible
            if y == 0 || x == 0 || y == h - 1 || x == w - 1 {
                visibilities[y][x] = true;
                continue;
            }

            // TODO: There's an optimization opportunity here if needed. I could move these checks
            // into functions and then call them in order depending on current x/y so that smaller
            // side is checked first.

            let column = heights.iter().map(|row| row[x]).collect_vec();
            let row = &heights[y];

            // check top visibility
            if column[..y].iter().all(|c| c < &height) {
                visibilities[y][x] = true;
                continue;
            }

            // check left visibility
            if row[..x].iter().all(|t| t < &height) {
                visibilities[y][x] = true;
                continue;
            }

            // check bottom visibility
            if column[y + 1..].iter().all(|c| c < &height) {
                visibilities[y][x] = true;
                continue;
            }

            // check right visibility
            if row[x + 1..].iter().all(|t| t < &height) {
                visibilities[y][x] = true;
                continue;
            }
        }
    }
    Some(
        visibilities
            .iter()
            .flatten()
            .filter(|t| **t)
            .count()
            .try_into()
            .unwrap(),
    )
}

pub fn part_two(input: &str) -> Option<u32> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 8);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 8);
        assert_eq!(part_one(&input), Some(21));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 8);
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 8);
        assert_eq!(part_one(&input), Some(1733));
        assert_eq!(part_two(&input), None);
    }
}
