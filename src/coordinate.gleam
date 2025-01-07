import gleam/int
import gleam/list

pub type Coordinate {
  Coordinate(row: Int, column: Int)
}

pub type Direction {
  Up
  Down
  Left
  Right
}

const directions = [Up, Down, Left, Right]

pub fn new(row row: Int, column column: Int) {
  Coordinate(row: row, column: column)
}

pub fn next(coordinate, direction) {
  case direction {
    Up -> up(coordinate)
    Left -> left(coordinate)
    Down -> down(coordinate)
    Right -> right(coordinate)
  }
}

pub fn surrounding(coordinate) {
  list.map(directions, fn(direction) { next(coordinate, direction) })
}

pub fn right(coordinate) {
  map_column(coordinate, fn(column) { column + 1 })
}

pub fn left(coordinate) {
  map_column(coordinate, fn(column) { column - 1 })
}

pub fn up(coordinate) {
  map_row(coordinate, fn(row) { row - 1 })
}

pub fn down(coordinate) {
  map_row(coordinate, fn(row) { row + 1 })
}

fn map_row(coordinate, function) {
  Coordinate(..coordinate, row: function(coordinate.row))
}

fn map_column(coordinate, function) {
  Coordinate(..coordinate, column: function(coordinate.column))
}

pub fn to_string(coordinate: Coordinate) {
  int.to_string(coordinate.column) <> "," <> int.to_string(coordinate.row)
}
