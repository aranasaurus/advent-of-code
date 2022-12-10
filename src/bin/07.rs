use std::collections::BTreeMap;

use nom::{
    branch::alt,
    bytes::complete::{tag, take_till},
    character::complete::{digit1, newline, space1},
    multi::{separated_list0, separated_list1},
    sequence::separated_pair,
    IResult,
};

#[derive(Debug)]
enum Contents<'n> {
    File { size: u32 },
    Dir(&'n str),
}

#[derive(Debug)]
enum Command<'n> {
    ChangeDir(CD<'n>),
    List(Vec<Contents<'n>>),
}

#[derive(Debug)]
enum CD<'n> {
    Root,
    Up,
    Name(&'n str),
}

fn take_till_newline(input: &str) -> IResult<&str, &str> {
    take_till(|c| c == '\n')(input)
}

fn cd(input: &str) -> IResult<&str, Command> {
    let (input, _) = tag("$ cd ")(input)?;
    let (input, name) = take_till_newline(input)?;
    Ok((
        input,
        Command::ChangeDir(match name {
            ".." => CD::Up,
            "/" => CD::Root,
            _ => CD::Name(name),
        }),
    ))
}

fn ls(input: &str) -> IResult<&str, Command> {
    let (input, _) = tag("$ ls")(input)?;
    let (input, _) = newline(input)?;
    let (input, contents) = separated_list0(newline, alt((file, dir)))(input)?;
    Ok((input, Command::List(contents)))
}

fn file(input: &str) -> IResult<&str, Contents> {
    let (input, (size, _)) = separated_pair(digit1, space1, take_till_newline)(input)?;

    Ok((
        input,
        Contents::File {
            size: size.parse().unwrap(),
        },
    ))
}

fn dir(input: &str) -> IResult<&str, Contents> {
    let (input, _) = tag("dir ")(input)?;
    let (input, name) = take_till_newline(input)?;
    Ok((input, Contents::Dir(name)))
}

fn commands(input: &str) -> IResult<&str, Vec<Command>> {
    separated_list1(newline, alt((ls, cd)))(input)
}

fn calc_sizes<'n>(
    (mut context, mut sizes): (Vec<&'n str>, BTreeMap<Vec<&'n str>, u32>),
    command: &'n Command,
) -> (Vec<&'n str>, BTreeMap<Vec<&'n str>, u32>) {
    match command {
        Command::ChangeDir(CD::Root) => {
            context.push("");
        }
        Command::ChangeDir(CD::Up) => {
            context.pop();
        }
        Command::ChangeDir(CD::Name(target)) => {
            context.push(target);
        }
        Command::List(contents) => {
            let sum = contents
                .iter()
                .filter_map(|item| {
                    if let Contents::File { size, .. } = item {
                        Some(size)
                    } else {
                        None
                    }
                })
                .sum::<u32>();

            for i in 0..context.len() {
                sizes
                    .entry(context[0..=i].to_vec())
                    .and_modify(|v| *v += sum)
                    .or_insert(sum);
            }
        }
    };
    (context, sizes)
}

pub fn part_one(input: &str) -> Option<u32> {
    let cmds = commands(input).unwrap().1;

    let (_, sizes) = cmds.iter().fold((vec![], BTreeMap::new()), calc_sizes);
    Some(
        sizes
            .iter()
            .filter_map(|(_, size)| if *size < 100000 { Some(size) } else { None })
            .sum::<u32>(),
    )
}

pub fn part_two(input: &str) -> Option<u32> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 7);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 7);
        assert_eq!(part_one(&input), Some(95437));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 7);
        assert_eq!(part_two(&input), None);
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 7);
        assert_eq!(part_one(&input), Some(1517599));
        assert_eq!(part_two(&input), None);
    }
}
