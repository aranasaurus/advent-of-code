fn score_round(opponent: i8, player: i8) -> u32 {
    let result = (player - opponent).rem_euclid(3);
    (match result {
        0 => player + 3, // draw
        1 => player + 6, // win
        2 => player,     // lose
        _ => unreachable!(),
    }) as u32
}

fn letter_to_player(letter: &str) -> i8 {
    match letter.trim() {
        "A" | "X" => 1,
        "B" | "Y" => 2,
        "C" | "Z" => 3,
        _ => unreachable!(),
    }
}

pub fn part_one(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .map(|line| {
                let (opp_str, player_str) = line.split_at(1);
                score_round(letter_to_player(opp_str), letter_to_player(player_str))
            })
            .sum(),
    )
}

pub fn part_two(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .map(|line| {
                let (opp_str, strat) = line.split_at(1);
                let opponent = letter_to_player(opp_str);
                // there's definitely a smarter way to do this, but I spent an hour on it and I give up for tonight!
                let player = match strat.trim() {
                    "X" => match opponent {
                        // lose
                        1 => 3,
                        2 => 1,
                        3 => 2,
                        _ => unreachable!(),
                    },
                    "Y" => opponent, // draw
                    "Z" => match opponent {
                        // win
                        1 => 2,
                        2 => 3,
                        3 => 1,
                        _ => unreachable!(),
                    },
                    _ => unreachable!(),
                };

                score_round(opponent, player)
            })
            .sum(),
    )
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
        assert_eq!(part_two(&input), Some(12));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 2);
        assert_eq!(part_one(&input), Some(10595));
        assert_eq!(part_two(&input), Some(9541));
    }
}
