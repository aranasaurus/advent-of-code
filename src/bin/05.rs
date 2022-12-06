use itertools::Itertools;
use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{self, alpha1, digit1, multispace1, newline, space1},
    multi::{many1, separated_list1},
    sequence::{delimited, preceded},
    IResult,
};

#[derive(Debug)]
struct Move {
    quantity: u8,
    from: usize,
    to: usize,
}

fn parse_crate(input: &str) -> IResult<&str, &str> {
    delimited(complete::char('['), alpha1, complete::char(']'))(input)
}

fn parse_crate_position(input: &str) -> IResult<&str, Option<&str>> {
    let (input, c) = alt((tag("   "), parse_crate))(input)?;

    let result = match c {
        "   " => None,
        value => Some(value),
    };
    Ok((input, result))
}

fn parse_crate_row(input: &str) -> IResult<&str, Vec<Option<&str>>> {
    separated_list1(complete::char(' '), parse_crate_position)(input)
}

fn parse_crates(input: &str) -> IResult<&str, Vec<Vec<&str>>> {
    let (input, crates_h) = separated_list1(newline, parse_crate_row)(input)?;
    let (input, _) = newline(input)?;
    let (input, _) = many1(preceded(space1, digit1))(input)?;
    let (input, _) = multispace1(input)?;

    let stack_count = crates_h.first().unwrap().len();
    let mut crates: Vec<Vec<&str>> = vec![vec![]; stack_count];
    for row in crates_h.iter().rev() {
        for (i, c) in row.iter().enumerate() {
            if let Some(c) = c {
                crates[i].push(*c);
            }
        }
    }
    Ok((input, crates))
}

fn parse_move(input: &str) -> IResult<&str, Move> {
    let (input, _) = tag("move ")(input)?;
    let (input, quantity) = complete::u8(input)?;
    let (input, _) = tag(" from ")(input)?;
    let (input, from) = complete::u32(input)?;
    let (input, _) = tag(" to ")(input)?;
    let (input, to) = complete::u32(input)?;
    Ok((
        input,
        Move {
            quantity,
            from: from as usize - 1,
            to: to as usize - 1,
        },
    ))
}

fn parse_moves(input: &str) -> IResult<&str, Vec<Move>> {
    separated_list1(newline, parse_move)(input)
}

pub fn part_one(input: &str) -> Option<String> {
    let (input, mut crates) = parse_crates(input).unwrap();
    let (_, moves) = parse_moves(input).unwrap();

    for m in moves.iter() {
        for _ in 0..m.quantity {
            if let Some(c) = crates[m.from].pop() {
                crates[m.to].push(c);
            }
        }
    }

    let result: String = crates.iter().filter_map(|c| c.last()).join("");
    Some(result)
}

pub fn part_two(_input: &str) -> Option<String> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 5);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 5);
        assert_eq!(part_one(&input), Some("CMZ".to_string()));
    }

    #[test]
    #[ignore]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 5);
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 5);
        assert_eq!(part_one(&input), Some("LJSVLTWQM".to_string()));
        assert_eq!(part_two(&input), None);
    }
}
