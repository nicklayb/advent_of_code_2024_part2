import day11/arrangement
import gleam/io
import gleam/list
import input

pub fn main() {
  input.challenge(11, part_1, part_2)
}

pub fn part_1(content) {
  let arrangement = arrangement.parse(content)
  let updated_arrangement =
    arrangement.evolve_until(arrangement, 25, fn(arrangement) {
      io.debug(arrangement)
    })

  list.length(updated_arrangement)
}

fn part_2(_content) {
  0
}
