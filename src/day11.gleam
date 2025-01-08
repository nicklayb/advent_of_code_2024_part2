import day11/arrangement
import gleam/io
import gleam/list
import input

pub fn main() {
  input.challenge(11, part_1, part_2)
}

fn part_1(content) {
  evolve_until(content, 25)
}

fn part_2(content) {
  evolve_until(content, 75)
}

fn evolve_until(content, length) {
  let arrangement = arrangement.parse(content)
  let updated_arrangement =
    arrangement.evolve_until(arrangement, length, fn(arrangement) {
      arrangement
    })

  list.length(updated_arrangement)
}
