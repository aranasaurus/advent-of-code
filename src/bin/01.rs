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

pub fn part_two(input: &str) -> Option<u32> {
    let mut top3 = [0 as u32; 3];
    let mut current_calories = 0 as u32;
    for line in input.lines() {
        if let Ok(calories) = line.parse::<u32>() {
            current_calories += calories;
        }

        if line.is_empty() {
            update_top3(current_calories, &mut top3);
            current_calories = 0;
        }
    }

    update_top3(current_calories, &mut top3);
    Some(top3.iter().sum())
}

// I know there's a better way to do this...
fn update_top3(current_calories: u32, top3: &mut [u32; 3]) {
    if current_calories > top3[0] {
        top3[2] = top3[1];
        top3[1] = top3[0];
        top3[0] = current_calories;
    } else if current_calories > top3[1] {
        top3[2] = top3[1];
        top3[1] = current_calories;
    } else if current_calories > top3[2] {
        top3[2] = current_calories;
    }
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
        assert_eq!(part_two(&input), Some(45000));
    }
}
