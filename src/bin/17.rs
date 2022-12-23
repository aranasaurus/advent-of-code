use std::collections::HashMap;

use itertools::Itertools;

#[derive(Clone, Debug)]
enum Move {
    Left,
    Right,
}

#[derive(Clone, Debug)]
enum Shape {
    Line,
    Cross,
    Angle,
    Stick,
    Square,
}

const EMPTY_ROW: u16 = 0b100000001;

impl Shape {
    fn bits(&self) -> Vec<u16> {
        match self {
            Shape::Line => vec![0b111100000, 0b000000000, 0b0000000000, 0b000000000],
            Shape::Cross => vec![0b010000000, 0b111000000, 0b010000000, 0b000000000],
            Shape::Angle => vec![0b001000000, 0b001000000, 0b111000000, 0b000000000],
            Shape::Stick => vec![0b100000000, 0b100000000, 0b100000000, 0b100000000],
            Shape::Square => vec![0b110000000, 0b110000000, 0b000000000, 0b000000000],
        }
    }

    fn height(&self) -> usize {
        match self {
            Shape::Line => 1,
            Shape::Cross => 3,
            Shape::Angle => 3,
            Shape::Stick => 4,
            Shape::Square => 2,
        }
    }
}

const SHAPE_LIST: [Shape; 5] = [
    Shape::Line,
    Shape::Cross,
    Shape::Angle,
    Shape::Stick,
    Shape::Square,
];

type Point = (usize, usize);

#[derive(Debug)]
struct Rock<'a> {
    shape: &'a Shape,
    point: Point,
}

impl Rock<'_> {
    fn height(&self) -> usize {
        self.shape.height()
    }

    fn shifted_bits(&self) -> Vec<u16> {
        self.shape
            .bits()
            .iter()
            .map(|b| b >> self.point.0)
            .collect_vec()
    }

    fn row_at_y(&self, y: usize) -> Option<u16> {
        if let Some(local_y) = self.point.1.checked_sub(y) {
            let bits = self.shifted_bits();
            if local_y < bits.len() {
                let row = bits[local_y];
                if row > 0 {
                    Some(row)
                } else {
                    None
                }
            } else {
                None
            }
        } else {
            None
        }
    }
}

#[derive(Debug)]
struct Tower {
    grid: Vec<u16>,
    move_list: Vec<Move>,
    height: u64,
}

impl Tower {
    fn pattern_state(&self) -> u64 {
        let bit_width = 9;
        (self.grid[self.height as usize - 1] as u64) << (bit_width * 6)
            | (self.grid[self.height as usize - 2] as u64) << (bit_width * 5)
            | (self.grid[self.height as usize - 3] as u64) << (bit_width * 4)
            | (self.grid[self.height as usize - 4] as u64) << (bit_width * 3)
            | (self.grid[self.height as usize - 5] as u64) << (bit_width * 2)
            | (self.grid[self.height as usize - 6] as u64) << bit_width
            | (self.grid[self.height as usize - 7] as u64)
    }

    fn spawn_rock(&mut self, shape: &Shape, move_index: &mut usize) {
        let shape_height = shape.height();
        let mut r = Rock {
            shape,
            point: (3, self.height as usize + shape_height + 3),
        };

        while self.grid.len() <= r.point.1 + 1 {
            self.grid.push(EMPTY_ROW);
        }

        loop {
            let next_move = &self.move_list[*move_index];
            *move_index = (*move_index + 1) % self.move_list.len();
            self.perform_move(&mut r, next_move);
            if !self.move_down(&mut r) {
                self.apply_move(&r);
                self.height = self.height.max(r.point.1 as u64);
                return;
            }
        }
    }

    fn perform_move(&self, r: &mut Rock, m: &Move) {
        let x = r.point.0;
        let target_x = match m {
            Move::Left => x - 1,
            Move::Right => x + 1,
        };

        let mut can_move = true;
        let bits = r.shifted_bits();
        for (i, row) in bits.iter().filter(|&&b| b != 0).enumerate() {
            let y = r.point.1 - i;
            let target = match m {
                Move::Left => row << 1,
                Move::Right => row >> 1,
            };
            if self.grid[y] & target != 0 {
                can_move = false;
                break;
            }
        }

        if can_move {
            r.point.0 = target_x;
        }
    }

    fn apply_move(&mut self, r: &Rock) {
        for (i, &row) in r.shifted_bits().iter().enumerate() {
            if row == 0 {
                continue;
            }
            if let Some(y) = r.point.1.checked_sub(i) {
                self.grid[y] |= row;
            }
        }
    }

    fn move_down(&self, r: &mut Rock) -> bool {
        let y = r.point.1;
        if y <= r.height() {
            return false;
        }

        let test_ys = y - r.height() - 1..=y - 1;
        let mut can_move = true;
        for test_y in test_ys {
            let grid_bits = self.grid[test_y];
            if let Some(rock_bits) = r.row_at_y(test_y + 1) {
                if grid_bits & rock_bits != 0 {
                    can_move = false;
                    break;
                }
            }
        }

        if can_move {
            r.point.1 -= 1;
        }

        can_move
    }
}

fn parse_moves(input: &str) -> Vec<Move> {
    input
        .chars()
        .flat_map(|c| match c {
            '>' => Some(Move::Right),
            '<' => Some(Move::Left),
            _ => None,
        })
        .collect_vec()
}

fn run_sim(input: &str, iterations: u64) -> Option<u64> {
    let move_list = parse_moves(input);
    let mut move_index = 0usize;
    let mut shape_index = 0usize;

    let mut tower = Tower {
        grid: vec![EMPTY_ROW; 7],
        move_list,
        height: 0,
    };
    tower.grid[0] = u16::MAX;

    let mut patterns = HashMap::new();
    let mut rocks_spawned = 0;

    patterns.insert(
        (shape_index, move_index, 0u64),
        (tower.height, rocks_spawned),
    );

    while rocks_spawned < iterations {
        tower.spawn_rock(&SHAPE_LIST[shape_index], &mut move_index);
        rocks_spawned += 1;
        shape_index = (shape_index + 1) % SHAPE_LIST.len();

        if tower.height < 7 {
            continue;
        }

        // Check for repeatable patterns
        let key = (shape_index, move_index, tower.pattern_state());
        if let Some((pattern_height_start, pattern_rock_count_start)) = patterns.get(&key) {
            let pattern_rows = tower.height - pattern_height_start;
            let pattern_size = rocks_spawned - pattern_rock_count_start;

            let rocks_needed_to_complete_sim = iterations - rocks_spawned;
            let pattern_applications = rocks_needed_to_complete_sim / pattern_size;
            let additional_rocks_to_spawn = rocks_needed_to_complete_sim % pattern_size;
            let height_gained_from_pattern_applications = pattern_rows * pattern_applications;

            println!("found {pattern_size}-rock pattern after spawning {rocks_spawned} manually ({rocks_needed_to_complete_sim} to go)");
            println!("current tower height is {}", tower.height);
            println!("pattern is {pattern_rows} rows high");

            println!("manually simulating {additional_rocks_to_spawn} remaining rocks");
            for _ in 0..additional_rocks_to_spawn {
                tower.spawn_rock(&SHAPE_LIST[shape_index], &mut move_index);
                shape_index = (shape_index + 1) % SHAPE_LIST.len();
                rocks_spawned += 1;
            }

            println!(
                "tower height is now {} and we've spawned {rocks_spawned} rocks",
                tower.height
            );
            println!(
                "applying pattern {pattern_applications} times, skipping {} rock simulations, adding {height_gained_from_pattern_applications} rows",
                pattern_size * pattern_applications
            );
            rocks_spawned += pattern_size * pattern_applications;
            tower.height += height_gained_from_pattern_applications;
        } else {
            patterns.insert(key, (tower.height, rocks_spawned));
        }
    }

    Some(tower.height)
}

pub fn part_one(input: &str) -> Option<u64> {
    run_sim(input, 2022)
}

pub fn part_two(input: &str) -> Option<u64> {
    run_sim(input, 1000000000000)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 17);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 17);
        assert_eq!(part_one(&input), Some(3068));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 17);
        assert_eq!(part_two(&input), Some(1514285714288));
    }

    #[test]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 17);
        assert_eq!(part_one(&input), Some(3059));
        assert_eq!(part_two(&input) < Some(1516860465099), true);
    }

    #[test]
    fn test_line() {
        let mut r = Rock {
            shape: &Shape::Line,
            point: (2, 4),
        };

        assert_eq!(r.height(), 1);

        assert_eq!(r.shifted_bits(), vec![0b001111000, 0, 0, 0]);

        // check the 4 ys within the range of the 4-item shape bits array
        assert_eq!(r.row_at_y(r.point.1), Some(0b001111000));
        assert_eq!(r.row_at_y(r.point.1 - 1), None);
        assert_eq!(r.row_at_y(r.point.1 - 2), None);
        assert_eq!(r.row_at_y(r.point.1 - 3), None);

        // anything outside of that array's coverage should be None
        assert_eq!(r.row_at_y(5), None);
        assert_eq!(r.row_at_y(0), None);

        // modifying x should change the output
        r.point.0 += 2;
        assert_eq!(r.shifted_bits(), vec![0b000011110, 0, 0, 0]);

        // modifying y shouldn't change the output
        r.point.1 -= 2;
        assert_eq!(r.shifted_bits(), vec![0b000011110, 0, 0, 0]);

        let tower = Tower {
            grid: vec![EMPTY_ROW; 5],
            move_list: vec![],
            height: 0,
        };

        // this should bump the right edge and not allow the move
        assert_eq!(r.point, (4, 2));
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (4, 2));

        // check bumping into the left edge
        r.point.0 = 1;
        assert_eq!(r.point, (1, 2));
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 2));
    }

    #[test]
    fn test_cross() {
        let mut r = Rock {
            shape: &Shape::Cross,
            point: (2, 4),
        };

        assert_eq!(r.height(), 3);

        assert_eq!(
            r.shifted_bits(),
            vec![0b000100000, 0b001110000, 0b000100000, 0]
        );

        // check the 4 ys within the range of the 4-item shape bits array
        assert_eq!(r.row_at_y(r.point.1), Some(0b000100000));
        assert_eq!(r.row_at_y(r.point.1 - 1), Some(0b001110000));
        assert_eq!(r.row_at_y(r.point.1 - 2), Some(0b000100000));
        assert_eq!(r.row_at_y(r.point.1 - 3), None);

        // anything outside of that array's coverage should be None
        assert_eq!(r.row_at_y(5), None);
        assert_eq!(r.row_at_y(0), None);

        // modifying x should change the output
        r.point.0 += 2;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000001000, 0b000011100, 0b000001000, 0]
        );

        // modifying y shouldn't change the output
        r.point.1 -= 1;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000001000, 0b000011100, 0b000001000, 0]
        );

        let mut tower = Tower {
            grid: vec![EMPTY_ROW; 5],
            move_list: vec![],
            height: 0,
        };
        tower.grid[0] = u16::MAX;

        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (5, 3));
        // this should bump the right edge and not allow the move
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (5, 3));

        // check bumping into the left edge
        r.point.0 = 1;
        assert_eq!(r.point, (1, 3));
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 3));

        // check interactions with other blocks
        let mut angle = Rock {
            shape: &Shape::Angle,
            point: (2, 3),
        };
        tower.perform_move(&mut angle, &Move::Right);
        assert_eq!(tower.move_down(&mut angle), false);
        tower.apply_move(&angle);
        assert_eq!(angle.point, (3, 3));

        r.point = (1, 4);
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (2, 4));
        // this should bump into the angle and not move
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (2, 4));

        // this should bump into the lower part of the angle
        assert_eq!(tower.move_down(&mut r), false);
        assert_eq!(r.point, (2, 4));

        // this should be successful
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 4));

        // as should this
        assert_eq!(tower.move_down(&mut r), true);
        assert_eq!(r.point, (1, 3));

        // now we should hit the floor (and the angle, technically)
        assert_eq!(tower.move_down(&mut r), false);
        tower.apply_move(&r);

        assert_eq!(tower.grid[3], 0b101001001);
        assert_eq!(tower.grid[2], 0b111101001);
        assert_eq!(tower.grid[1], 0b101111001);
    }

    #[test]
    fn test_angle() {
        let mut r = Rock {
            shape: &Shape::Angle,
            point: (2, 4),
        };

        assert_eq!(r.height(), 3);

        assert_eq!(
            r.shifted_bits(),
            vec![0b000010000, 0b000010000, 0b001110000, 0]
        );

        // check the 4 ys within the range of the 4-item shape bits array
        assert_eq!(r.row_at_y(r.point.1), Some(0b000010000));
        assert_eq!(r.row_at_y(r.point.1 - 1), Some(0b000010000));
        assert_eq!(r.row_at_y(r.point.1 - 2), Some(0b001110000));
        assert_eq!(r.row_at_y(r.point.1 - 3), None);

        // anything outside of that array's coverage should be None
        assert_eq!(r.row_at_y(5), None);
        assert_eq!(r.row_at_y(0), None);

        // modifying x should change the output
        r.point.0 += 2;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000000100, 0b000000100, 0b000011100, 0]
        );

        // modifying y shouldn't change the output
        r.point.1 -= 1;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000000100, 0b000000100, 0b000011100, 0]
        );

        let mut tower = Tower {
            grid: vec![EMPTY_ROW; 5],
            move_list: vec![],
            height: 0,
        };
        tower.grid[0] = u16::MAX;

        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (5, 3));
        // this should bump the right edge and not allow the move
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (5, 3));

        // check bumping into the left edge
        r.point.0 = 1;
        assert_eq!(r.point, (1, 3));
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 3));
    }

    #[test]
    fn test_stick() {
        let mut r = Rock {
            shape: &Shape::Stick,
            point: (2, 4),
        };

        assert_eq!(r.height(), 4);

        assert_eq!(
            r.shifted_bits(),
            vec![0b001000000, 0b001000000, 0b001000000, 0b001000000]
        );

        // check the 4 ys within the range of the 4-item shape bits array
        assert_eq!(r.row_at_y(r.point.1), Some(0b001000000));
        assert_eq!(r.row_at_y(r.point.1 - 1), Some(0b001000000));
        assert_eq!(r.row_at_y(r.point.1 - 2), Some(0b001000000));
        assert_eq!(r.row_at_y(r.point.1 - 3), Some(0b001000000));

        // anything outside of that array's coverage should be None
        assert_eq!(r.row_at_y(5), None);
        assert_eq!(r.row_at_y(0), None);

        // modifying x should change the output
        r.point.0 += 2;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000010000, 0b000010000, 0b000010000, 0b000010000]
        );

        // modifying y shouldn't change the output
        r.point.1 += 1;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000010000, 0b000010000, 0b000010000, 0b000010000]
        );

        let mut tower = Tower {
            grid: vec![EMPTY_ROW; 6],
            move_list: vec![],
            height: 0,
        };
        tower.grid[0] = u16::MAX;

        r.point.0 = 6;
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (7, 5));
        // this should bump the right edge and not allow the move
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (7, 5));

        // check bumping into the left edge
        r.point.0 = 1;
        assert_eq!(r.point, (1, 5));
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 5));
    }

    #[test]
    fn test_square() {
        let mut r = Rock {
            shape: &Shape::Square,
            point: (2, 4),
        };

        assert_eq!(r.height(), 2);

        assert_eq!(
            r.shifted_bits(),
            vec![0b001100000, 0b001100000, 0b000000000, 0b000000000]
        );

        // check the 4 ys within the range of the 4-item shape bits array
        assert_eq!(r.row_at_y(r.point.1), Some(0b001100000));
        assert_eq!(r.row_at_y(r.point.1 - 1), Some(0b001100000));
        assert_eq!(r.row_at_y(r.point.1 - 2), None);
        assert_eq!(r.row_at_y(r.point.1 - 3), None);

        // anything outside of that array's coverage should be None
        assert_eq!(r.row_at_y(5), None);
        assert_eq!(r.row_at_y(0), None);

        // modifying x should change the output
        r.point.0 += 2;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000011000, 0b000011000, 0b000000000, 0b000000000]
        );

        // modifying y shouldn't change the output
        r.point.1 += 1;
        assert_eq!(
            r.shifted_bits(),
            vec![0b000011000, 0b000011000, 0b000000000, 0b000000000]
        );

        let mut tower = Tower {
            grid: vec![EMPTY_ROW; 6],
            move_list: vec![],
            height: 0,
        };
        tower.grid[0] = u16::MAX;

        r.point.0 = 5;
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (6, 5));
        // this should bump the right edge and not allow the move
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (6, 5));

        // check bumping into the left edge
        r.point.0 = 1;
        assert_eq!(r.point, (1, 5));
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 5));
    }

    #[test]
    fn test_tower() {
        let mut tower = Tower {
            grid: vec![EMPTY_ROW; 5],
            move_list: vec![],
            height: 0,
        };
        let mut r = Rock {
            shape: &Shape::Line,
            point: (3, 4),
        };

        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (4, 4));

        assert_eq!(tower.move_down(&mut r), true);
        assert_eq!(r.point, (4, 3));

        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (4, 3));

        assert_eq!(tower.move_down(&mut r), true);
        assert_eq!(r.point, (4, 2));

        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (4, 2));

        assert_eq!(tower.move_down(&mut r), true);
        assert_eq!(r.point, (4, 1));

        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (3, 1));

        assert_eq!(tower.move_down(&mut r), false);
        assert_eq!(r.point, (3, 1));

        tower.apply_move(&mut r);
        assert_eq!(tower.grid[1], 0b100111101);

        for _ in 1..=6 {
            tower.grid.push(0);
        }

        r = Rock {
            shape: &Shape::Cross,
            point: (3, 7),
        };

        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (2, 7));
        assert_eq!(tower.move_down(&mut r), true);
        assert_eq!(r.point, (2, 6));

        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (3, 6));
        assert_eq!(tower.move_down(&mut r), true);
        assert_eq!(r.point, (3, 5));

        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (2, 5));
        assert_eq!(tower.move_down(&mut r), true);
        assert_eq!(r.point, (2, 4));

        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (3, 4));
        assert_eq!(tower.move_down(&mut r), false);
        assert_eq!(r.point, (3, 4));

        tower.apply_move(&mut r);
        assert_eq!(tower.grid[1], 0b100111101);
        assert_eq!(tower.grid[2], 0b100010001);
        assert_eq!(tower.grid[3], 0b100111001);
        assert_eq!(tower.grid[4], 0b100010001);
    }

    #[test]
    fn test_tower_edges() {
        let mut tower = Tower {
            grid: vec![EMPTY_ROW; 6],
            move_list: vec![],
            height: 0,
        };
        let mut r = Rock {
            shape: &Shape::Angle,
            point: (3, 4),
        };

        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (2, 4));
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 4));
        tower.perform_move(&mut r, &Move::Left);
        assert_eq!(r.point, (1, 4));
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (2, 4));
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (3, 4));
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (4, 4));
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (5, 4));
        tower.perform_move(&mut r, &Move::Right);
        assert_eq!(r.point, (5, 4));
        tower.apply_move(&r);
        assert_eq!(tower.grid[4], 0b100000011);
        assert_eq!(tower.grid[3], 0b100000011);
        assert_eq!(tower.grid[2], 0b100001111);
    }
}
