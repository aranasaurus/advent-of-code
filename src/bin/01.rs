pub fn part_one(input: &str) -> Option<u32> {
    let mut max_calories = 0 as u32;
    let mut current_calories = 0 as u32;
    for line in input.lines() {
        if line.is_empty() {
            max_calories = if current_calories > max_calories { current_calories } else { max_calories };
            current_calories = 0;
        } else {
            current_calories += line.parse::<u32>().unwrap();
        }
    }
    
    Some(max_calories)
}

pub fn part_two(_input: &str) -> Option<u32> {
    None
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 1);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 1);
        assert_eq!(part_one(&input), Some(24000));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 1);
        assert_eq!(part_two(&input), None);
    }
}
