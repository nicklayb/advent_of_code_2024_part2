import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import input

pub fn main() {
  input.challenge(1, part_1, part_2)
}

fn part_1(content) {
  let #(left_list, right_list) = parse_input(content)
  let left_list = list.sort(left_list, by: int.compare)
  let right_list = list.sort(right_list, by: int.compare)
  find_distance(left_list, right_list, 0)
}

fn find_distance(left_list, right_list, acc) {
  case left_list, right_list {
    [left_item, ..left_rest], [right_item, ..right_rest] -> {
      let new_acc = acc + int.absolute_value(left_item - right_item)
      find_distance(left_rest, right_rest, new_acc)
    }
    _, _ -> acc
  }
}

fn part_2(content) {
  let #(left_list, right_list) = parse_input(content)

  list.fold(left_list, 0, fn(acc, item) {
    let count = list.count(right_list, fn(element) { element == item })
    acc + { item * count }
  })
}

fn parse_input(content) {
  content
  |> string.split("\n")
  |> list.fold(#([], []), fn(acc, line) {
    let #(left_list, right_list) = acc
    case parse_line(line) {
      Some(#(left_int, right_int)) -> {
        #([left_int, ..left_list], [right_int, ..right_list])
      }
      None -> acc
    }
  })
}

fn parse_line(line) {
  case string.split(line, "   ") {
    [left, right, ..] -> {
      let assert Ok(left_int) = int.parse(left)
      let assert Ok(right_int) = int.parse(right)
      Some(#(left_int, right_int))
    }
    _ -> None
  }
}
