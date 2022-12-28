use std::collections::HashMap;

use nom::{
    bytes::complete::tag, character::complete::line_ending, multi::separated_list1, IResult,
};
use rayon::{iter::ParallelIterator, prelude::IntoParallelRefIterator};

fn parse_blueprint(input: &str) -> IResult<&str, Blueprint> {
    use nom::character::complete::u32;
    let (input, _) = tag("Blueprint ")(input)?;
    let (input, id) = u32(input)?;
    let (input, _) = tag(": Each ore robot costs ")(input)?;
    let (input, ore_cost) = u32(input)?;
    let (input, _) = tag(" ore. Each clay robot costs ")(input)?;
    let (input, clay_cost) = u32(input)?;
    let (input, _) = tag(" ore. Each obsidian robot costs ")(input)?;
    let (input, obsidian_ore_cost) = u32(input)?;
    let (input, _) = tag(" ore and ")(input)?;
    let (input, obsidian_clay_cost) = u32(input)?;
    let (input, _) = tag(" clay. Each geode robot costs ")(input)?;
    let (input, geode_ore_cost) = u32(input)?;
    let (input, _) = tag(" ore and ")(input)?;
    let (input, geode_obsidian_cost) = u32(input)?;
    let (input, _) = tag(" obsidian.")(input)?;

    Ok((
        input,
        Blueprint {
            id,
            ore_cost,
            clay_cost,
            obsidian_cost: (obsidian_ore_cost, obsidian_clay_cost),
            geode_cost: (geode_ore_cost, geode_obsidian_cost),
            max_ore_spend: clay_cost.max(obsidian_ore_cost).max(geode_ore_cost),
            max_clay_spend: obsidian_clay_cost,
            max_obsidian_spend: geode_obsidian_cost,
        },
    ))
}

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
struct Resources {
    minutes: u32,
    ore: u32,
    clay: u32,
    obsidian: u32,
    geodes: u32,
    ore_bots: u32,
    clay_bots: u32,
    obsidian_bots: u32,
    geode_bots: u32,
}

impl Default for Resources {
    fn default() -> Self {
        Self {
            minutes: Default::default(),
            ore: Default::default(),
            clay: Default::default(),
            obsidian: Default::default(),
            geodes: Default::default(),
            ore_bots: 1,
            clay_bots: Default::default(),
            obsidian_bots: Default::default(),
            geode_bots: Default::default(),
        }
    }
}

impl Resources {
    fn advanced_by(&self, time: u32) -> Resources {
        let mut result = self.clone();
        result.minutes -= time;
        result.ore += self.ore_bots * time;
        result.clay += self.clay_bots * time;
        result.obsidian += self.obsidian_bots * time;
        result.geodes += self.geode_bots * time;
        result
    }

    fn make_ore_bot(&mut self, blueprint: &Blueprint) {
        self.ore -= blueprint.ore_cost;
        self.ore_bots += 1;
    }

    fn make_clay_bot(&mut self, blueprint: &Blueprint) {
        self.ore -= blueprint.clay_cost;
        self.clay_bots += 1;
    }

    fn make_obsidian_bot(&mut self, blueprint: &Blueprint) {
        self.ore -= blueprint.obsidian_cost.0;
        self.clay -= blueprint.obsidian_cost.1;
        self.obsidian_bots += 1;
    }

    fn make_geode_bot(&mut self, blueprint: &Blueprint) {
        self.ore -= blueprint.geode_cost.0;
        self.obsidian -= blueprint.geode_cost.1;
        self.geode_bots += 1;
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct Blueprint {
    id: u32,
    ore_cost: u32,
    clay_cost: u32,
    obsidian_cost: (u32, u32),
    geode_cost: (u32, u32),

    max_ore_spend: u32,
    max_clay_spend: u32,
    max_obsidian_spend: u32,
}

impl Blueprint {
    fn max_geodes(
        &self,
        res: Resources,
        cache: &mut HashMap<Resources, u32>,
        time_map: &mut Vec<u32>,
    ) -> u32 {
        if res.minutes == 0 {
            return res.geodes;
        }

        // If we've already calculated a strategy that has more geodes at this minute, we're wasting our time.
        if time_map[res.minutes as usize] > res.geodes {
            return 0;
        }

        if let Some(&result) = cache.get(&res) {
            return result;
        }

        // this is the amount of geodes we'd have if we did nothing and just let our bots collect until time ran out.
        let mut max_result = res.geodes + res.geode_bots * res.minutes;

        // do we need ore bots? (can we make more bots than we could spend in the remaining time)
        if res.ore_bots * res.minutes
            < (self.max_ore_spend * res.minutes)
                .checked_sub(res.ore)
                .unwrap_or(0)
        {
            // can we build one?
            if res.ore >= self.ore_cost {
                let mut updated_res = res.advanced_by(1);
                updated_res.make_ore_bot(self);
                max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
            } else {
                // could we build one if we waited?
                let needed = self.ore_cost - res.ore;
                let wait = (needed as f32 / res.ore_bots as f32).ceil() as u32;
                if wait < res.minutes {
                    let mut updated_res = res.advanced_by(wait + 1);
                    updated_res.make_ore_bot(self);
                    max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
                }
            }
        }

        // do we need clay bots? (can we make more bots than we could spend in the remaining time)
        if res.clay_bots * res.minutes
            < (self.max_clay_spend * res.minutes)
                .checked_sub(res.clay)
                .unwrap_or(0)
        {
            // can we build one?
            if res.ore >= self.clay_cost {
                let mut updated_res = res.advanced_by(1);
                updated_res.make_clay_bot(self);
                max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
            } else {
                // could we build one if we waited?
                let needed = self.clay_cost - res.ore;
                let wait = (needed as f32 / res.ore_bots as f32).ceil() as u32;
                if wait < res.minutes {
                    let mut updated_res = res.advanced_by(wait + 1);
                    updated_res.make_clay_bot(self);
                    max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
                }
            }
        }

        // do we need obsidian bots? (can we make more bots than we could spend in the remaining time)
        if res.obsidian_bots * res.minutes
            < (self.max_obsidian_spend * res.minutes)
                .checked_sub(res.obsidian)
                .unwrap_or(0)
        {
            // can we build one?
            let cost = self.obsidian_cost;
            if res.ore >= cost.0 && res.clay >= cost.1 {
                let mut updated_res = res.advanced_by(1);
                updated_res.make_obsidian_bot(self);
                max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
            } else {
                // could we build one if we waited?
                let needed_ore = if res.ore < cost.0 {
                    cost.0 - res.ore
                } else {
                    0
                };
                let needed_clay = if res.clay < cost.1 {
                    cost.1 - res.clay
                } else {
                    0
                };
                let ore_wait = (needed_ore as f32 / res.ore_bots as f32).ceil() as u32;
                let clay_wait = (needed_clay as f32 / res.clay_bots as f32).ceil() as u32;
                let wait = ore_wait.max(clay_wait);
                if wait < res.minutes {
                    let mut updated_res = res.advanced_by(wait + 1);
                    updated_res.make_obsidian_bot(self);
                    max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
                }
            }
        }

        // can we build a geode bot?
        let cost = self.geode_cost;
        if res.ore >= cost.0 && res.obsidian >= cost.1 {
            let mut updated_res = res.advanced_by(1);
            updated_res.make_geode_bot(self);
            max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
        } else {
            // could we build one if we waited?
            let needed_ore = if res.ore < cost.0 {
                cost.0 - res.ore
            } else {
                0
            };
            let needed_obsidian = if res.obsidian < cost.1 {
                cost.1 - res.obsidian
            } else {
                0
            };
            let ore_wait = (needed_ore as f32 / res.ore_bots as f32).ceil() as u32;
            let obsidian_wait = (needed_obsidian as f32 / res.obsidian_bots as f32).ceil() as u32;
            let wait = ore_wait.max(obsidian_wait);
            if wait < res.minutes {
                let mut updated_res = res.advanced_by(wait + 1);
                updated_res.make_geode_bot(self);
                max_result = max_result.max(self.max_geodes(updated_res, cache, time_map));
            }
        }

        cache.insert(res.clone(), max_result);
        time_map[res.minutes as usize] = time_map[res.minutes as usize].max(res.geodes);
        max_result
    }

    fn quality(&self, resources: Resources) -> u32 {
        let mut cache = HashMap::new();
        let mut time_map = vec![0; resources.minutes as usize + 1];
        let max_geodes = self.max_geodes(resources, &mut cache, &mut time_map);
        // dbg!(self);
        // dbg!(cache.keys().len());
        // dbg!(max_geodes);
        max_geodes * self.id
    }
}

pub fn part_one(input: &str) -> Option<u32> {
    let (_, blueprints) = separated_list1(line_ending, parse_blueprint)(input).unwrap();

    let duration = 24;
    let result = blueprints
        .par_iter()
        .map(|blueprint| {
            let resources = Resources {
                minutes: duration,
                ..Default::default()
            };
            blueprint.quality(resources)
        })
        .sum();
    Some(result)
}

pub fn part_two(input: &str) -> Option<u32> {
    let (_, mut blueprints) = separated_list1(line_ending, parse_blueprint)(input).unwrap();
    blueprints.truncate(3);

    let duration = 32;
    let result = blueprints
        .par_iter()
        .map(|blueprint| {
            let resources = Resources {
                minutes: duration,
                ..Default::default()
            };
            let mut cache = HashMap::new();
            let mut time_map = vec![0; duration as usize + 1];
            let max_geodes = blueprint.max_geodes(resources, &mut cache, &mut time_map);
            // dbg!(cache.keys().len());
            max_geodes
        })
        .product();
    Some(result)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 19);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 19);
        assert_eq!(part_one(&input), Some(33));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 19);
        assert_eq!(part_two(&input), Some(56 * 62));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 19);
        assert_eq!(part_one(&input), Some(1294));
        assert_eq!(part_two(&input), Some(13640));
    }
}
