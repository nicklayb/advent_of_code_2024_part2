import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub type Rule {
  Zero
  Even
  None
}

const unapplying_multiplier = 2024

const rules = [Zero, Even]

pub fn parse(string) {
  string
  |> string.trim()
  |> string.split(" ")
  |> list.map(fn(part) {
    let assert Ok(int) = int.parse(part)
    int
  })
}

pub fn evolve_until(arrangement, generations, function) {
  internal_evolve_until(arrangement, 0, generations - 1, function)
}

fn internal_evolve_until(arrangement, current, maximum, function) {
  let new_arrangement = evolve(arrangement)
  function(new_arrangement)
  case new_arrangement == arrangement {
    True -> new_arrangement
    False -> {
      case current == maximum {
        True -> new_arrangement
        False ->
          internal_evolve_until(new_arrangement, current + 1, maximum, function)
      }
    }
  }
}

pub fn evolve(arrangement) {
  list.flat_map(arrangement, fn(part) {
    let rule = rule_applying(rules, part)

    apply_rule(part, rule)
  })
}

fn rule_applying(rules, part) {
  case rules {
    [rule, ..rest] -> {
      case check_rule(rule, part) {
        True -> rule
        False -> rule_applying(rest, part)
      }
    }
    [] -> None
  }
}

fn check_rule(rule, part) {
  case rule {
    Zero -> part == 0
    Even -> {
      let length =
        part
        |> int.to_string()
        |> string.length()

      int.is_even(length)
    }
    None -> True
  }
}

fn apply_rule(part, rule) {
  case rule {
    Zero -> [1]
    Even -> {
      let #(left, right) = split_even_number(part)
      [left, right]
    }
    None -> [part * unapplying_multiplier]
  }
}

fn split_even_number(number) {
  let string = int.to_string(number)
  let part_length = string.length(string) / 2
  let half = part_length - 1
  let left = string.slice(string, at_index: 0, length: part_length)
  let right = string.slice(string, at_index: half + 1, length: part_length)
  let assert Ok(left_int) = int.parse(left)
  let assert Ok(right_int) = int.parse(right)
  #(left_int, right_int)
}
