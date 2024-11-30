use itertools::Itertools;

use std::{
    collections::{HashMap, HashSet, VecDeque},
    hash::{Hash, Hasher},
};

use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{alpha1, line_ending},
    multi::separated_list1,
    IResult,
};

// TODO: Performance optimizations! This is by far the slowest solution (part 2 takes ~3 minutes in release)

#[derive(Debug)]
struct Valve {
    id: String,
    flow_rate: u32,
    connected_ids: Vec<String>,
}

fn valve(input: &str) -> IResult<&str, Valve> {
    let (input, _) = tag("Valve ")(input)?;
    let (input, id) = alpha1(input)?;
    let (input, _) = tag(" has flow rate=")(input)?;
    let (input, flow_rate) = nom::character::complete::u32(input)?;
    let (input, _) = alt((
        tag("; tunnels lead to valves "),
        tag("; tunnel leads to valve "),
    ))(input)?;
    let (input, connected_ids) = separated_list1(tag(", "), alpha1)(input)?;
    Ok((
        input,
        Valve {
            id: id.to_string(),
            flow_rate,
            connected_ids: connected_ids.iter().map(|id| id.to_string()).collect_vec(),
        },
    ))
}

#[derive(Clone)]
struct Walk {
    location: String,
    remaining_time: u32,
    open_valves: HashSet<String>,
    helper: bool,
}

impl PartialEq for Walk {
    fn eq(&self, other: &Self) -> bool {
        self.location == other.location
            && self.remaining_time == other.remaining_time
            && self.open_valves == other.open_valves
    }
}

impl Eq for Walk {}

impl Hash for Walk {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.location.hash(state);
        self.helper.hash(state);
        self.remaining_time.hash(state);
        self.open_valves.iter().sorted().for_each(|v| v.hash(state));
    }
}

fn bfs(
    walk: &Walk,
    valves: &HashMap<String, Valve>,
    shortcuts: &HashMap<String, HashMap<String, u32>>,
    seen: &mut HashMap<Walk, u32>,
) -> u32 {
    if let Some(answer) = seen.get(walk) {
        return *answer;
    }

    let mut max_flow = if walk.helper {
        bfs(
            &Walk {
                location: "AA".to_string(),
                remaining_time: 26,
                open_valves: walk.open_valves.clone(),
                helper: false,
            },
            valves,
            shortcuts,
            seen,
        )
    } else {
        0
    };

    if !walk.open_valves.contains(&walk.location) && walk.remaining_time > 0 {
        let mut open_valves = walk.open_valves.clone();
        open_valves.insert(walk.location.clone());
        let flow = valves.get(&walk.location).unwrap().flow_rate * (walk.remaining_time - 1);

        max_flow = max_flow.max(
            bfs(
                &Walk {
                    location: walk.location.clone(),
                    remaining_time: walk.remaining_time - 1,
                    open_valves,
                    helper: walk.helper,
                },
                valves,
                shortcuts,
                seen,
            ) + flow,
        );
    }

    let map = shortcuts.get(&walk.location).unwrap();

    for (dest, cost) in map {
        if *cost < walk.remaining_time {
            max_flow = max_flow.max(bfs(
                &Walk {
                    location: dest.to_string(),
                    remaining_time: walk.remaining_time - *cost,
                    open_valves: walk.open_valves.clone(),
                    helper: walk.helper,
                },
                valves,
                shortcuts,
                seen,
            ));
        }
    }

    seen.insert(walk.clone(), max_flow);
    max_flow
}

fn shortcuts(start: &String, valves: &HashMap<String, Valve>) -> HashMap<String, u32> {
    let mut seen = HashSet::new();
    let mut queue = VecDeque::new();
    let mut paths = HashMap::new();

    seen.insert(start);
    queue.push_back((start, 0u32));

    while let Some((node, dist)) = queue.pop_front() {
        let v = valves.get(node).unwrap();

        for path in &v.connected_ids {
            if !seen.insert(path) {
                continue;
            }

            let next = valves.get(path).unwrap();
            if next.flow_rate > 0 && &next.id != start {
                paths.insert(next.id.to_string(), dist + 1);
            }

            queue.push_back((&next.id, dist + 1));
        }
    }

    paths
}

fn parse(
    input: &str,
) -> (
    HashMap<String, Valve>,
    HashMap<String, HashMap<String, u32>>,
) {
    let (_, valves) = separated_list1(line_ending, valve)(input).unwrap();
    let mut valve_map = HashMap::new();
    let mut shortcuts_map = HashMap::new();
    for valve in &valves {
        valve_map.insert(
            valve.id.to_string(),
            Valve {
                id: valve.id.to_string(),
                flow_rate: valve.flow_rate,
                connected_ids: valve.connected_ids.clone(),
            },
        );
    }
    for v in valves {
        shortcuts_map.insert(v.id.clone(), shortcuts(&v.id, &valve_map));
    }
    (valve_map, shortcuts_map)
}

pub fn part_one(input: &str) -> Option<u32> {
    let (valve_map, shortcuts_map) = parse(input);

    let walk = Walk {
        location: "AA".to_string(),
        remaining_time: 30,
        open_valves: HashSet::new(),
        helper: false,
    };

    Some(bfs(&walk, &valve_map, &shortcuts_map, &mut HashMap::new()))
}

pub fn part_two(input: &str) -> Option<u32> {
    let (valve_map, shortcuts_map) = parse(input);

    let walk = Walk {
        location: "AA".to_string(),
        remaining_time: 26,
        open_valves: HashSet::new(),
        helper: true,
    };

    Some(bfs(&walk, &valve_map, &shortcuts_map, &mut HashMap::new()))
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 16);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 16);
        assert_eq!(part_one(&input), Some(1651));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 16);
        assert_eq!(part_two(&input), Some(1707));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 16);
        assert_eq!(part_one(&input), Some(1595));
        assert_eq!(part_two(&input), Some(2189));
    }
}
