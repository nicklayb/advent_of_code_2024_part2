import coordinate
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import input
import map

const minimum_height = 0

const maximum_height = 9

pub fn main() {
  input.challenge(10, part_1, part_2)
}

fn part_1(content) {
  let map = map.from_string(content, int.parse)

  map
  |> find_paths()
  |> dict.fold(0, fn(acc, _, paths) {
    let ends =
      paths
      |> list.unique()
      |> list.length()
    acc + ends
  })
}

fn find_paths(map) {
  map.reduce_safe(map, dict.new(), fn(acc, coordinate, item) {
    case item == minimum_height {
      True -> {
        case find_surrounding(map, coordinate, minimum_height + 1, []) {
          [] -> acc
          destinations -> dict.insert(acc, coordinate, destinations)
        }
      }
      _ -> acc
    }
  })
}

fn find_surrounding(map, coordinate, value, accumulator) {
  map
  |> map.reduce_surrounding(coordinate, accumulator, fn(acc, coordinate, item) {
    case item == value, value == maximum_height {
      True, True -> [coordinate, ..acc]
      True, False -> find_surrounding(map, coordinate, value + 1, acc)
      False, _ -> acc
    }
  })
}

fn part_2(content) {
  let map = map.from_string(content, int.parse)

  map
  |> find_paths()
  |> dict.fold(0, fn(acc, _, paths) { acc + list.length(paths) })
}
