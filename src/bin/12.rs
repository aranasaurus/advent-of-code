use itertools::Itertools;
use nom::{
    character::complete::{alpha1, newline},
    multi::separated_list1,
    IResult, Parser,
};
use petgraph::{algo, prelude::DiGraphMap};

fn parse_graph(
    input: &str,
) -> IResult<
    &str,
    (
        DiGraphMap<(isize, isize, char), ()>,
        (isize, isize),
        (isize, isize),
    ),
> {
    let (input, grid) =
        separated_list1(newline, alpha1.map(|row: &str| row.chars().collect_vec()))(input)?;

    let start = (0..grid.len())
        .cartesian_product(0..grid[0].len())
        .find_map(|(y, x)| {
            let c = grid[y][x];
            if c == 'S' {
                Some((x as isize, y as isize))
            } else {
                None
            }
        })
        .unwrap();
    let end = (0..grid.len())
        .cartesian_product(0..grid[0].len())
        .find_map(|(y, x)| {
            let c = grid[y][x];
            if c == 'E' {
                Some((x as isize, y as isize))
            } else {
                None
            }
        })
        .unwrap();

    let grid: Vec<Vec<char>> = grid
        .iter()
        .map(|row| {
            row.iter()
                .map(|c| match c {
                    'S' => 'a',
                    'E' => 'z',
                    other => *other,
                })
                .collect()
        })
        .collect();

    let edges = (0_isize..(grid.len() as isize))
        .cartesian_product(0_isize..(grid[0].len() as isize))
        .flat_map(|(y, x)| {
            let neighbors = vec![(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)];
            let c = (x, y);
            let c_height = grid[y as usize][x as usize];
            neighbors
                .iter()
                .filter_map(|n| {
                    grid.get(n.1 as usize)
                        .and_then(|row| row.get(n.0 as usize))
                        .and_then(|&neighbor_height| {
                            if c_height as u8 + 1 >= neighbor_height as u8 {
                                Some(((c.0, c.1, c_height), (n.0, n.1, neighbor_height)))
                            } else {
                                None
                            }
                        })
                })
                .collect_vec()
        })
        .collect::<Vec<((isize, isize, char), (isize, isize, char))>>();

    let graph = DiGraphMap::<(isize, isize, char), ()>::from_edges(&edges);
    Ok((input, (graph, start, end)))
}

pub fn part_one(input: &str) -> Option<u32> {
    let (_, (graph, start, end)) = parse_graph(input).unwrap();
    let result = algo::dijkstra(
        &graph,
        (start.0, start.1, 'a'),
        Some((end.0, end.1, 'z')),
        |_| 1,
    );
    Some(result[&(end.0, end.1, 'z')])
}

pub fn part_two(input: &str) -> Option<u32> {
    let (_, (graph, _, end)) = parse_graph(input).unwrap();
    // This works but it takes 5s(!) on the full input. Gonna need to find a faster way.
    //   -- huh, but only in DEBUG mode. --release runs it at 300ms
    let result = graph
        .nodes()
        .filter(|n| n.2 == 'a')
        .filter_map(|n| {
            let result = algo::dijkstra(&graph, n, Some((end.0, end.1, 'z')), |_| 1);
            result.get(&(end.0, end.1, 'z')).cloned()
        })
        .min()
        .unwrap();
    Some(result)
}

fn main() {
    let input = &advent_of_code::read_file("inputs", 12);
    advent_of_code::solve!(1, part_one, input);
    advent_of_code::solve!(2, part_two, input);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_one() {
        let input = advent_of_code::read_file("examples", 12);
        assert_eq!(part_one(&input), Some(31));
    }

    #[test]
    fn test_part_two() {
        let input = advent_of_code::read_file("examples", 12);
        assert_eq!(part_two(&input), Some(29));
    }

    #[test]
    #[ignore]
    fn test_solutions() {
        let input = advent_of_code::read_file("inputs", 12);
        assert_eq!(part_one(&input), Some(462));
        assert_eq!(part_two(&input), Some(451));
    }
}
