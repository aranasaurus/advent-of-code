fn score_round(round: &str) -> u32 {
    let players: Vec<i8> = round
        .split_whitespace()
        .map(|s| match s {
            "A" | "X" => 1,
            "B" | "Y" => 2,
            "C" | "Z" => 3,
            _ => unreachable!(),
        })
        .collect();

    let result = (players[1] - players[0]).rem_euclid(3);
    (match result {
        0 => players[1] + 3, // draw
        1 => players[1] + 6, // win
        2 => players[1],     // lose
        _ => unreachable!(),
    }) as u32
}

pub fn part_one(input: &str) -> Option<u32> {
    Some(input.lines().map(score_round).sum())
}

pub fn part_two(_input: &str) -> Option<u32> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 2);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 2);
        assert_eq!(part_one(&input), Some(15));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 2);
        assert_eq!(part_two(&input), None);
    }
}
