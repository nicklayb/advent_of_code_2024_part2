import coordinate.{type Coordinate}
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/string
import tools

pub type Map(a) {
  Map(width: Int, height: Int, dict: Dict(Coordinate, a))
}

pub fn new() {
  Map(width: 0, height: 0, dict: dict.new())
}

pub fn from_string(content, decode_value) {
  let #(_, map) =
    content
    |> string.split("\n")
    |> list.fold(#(0, new()), fn(acc, row) {
      let #(row_index, acc) = acc
      let #(_, acc) =
        row
        |> string.split("")
        |> list.fold(#(0, acc), fn(acc, char) {
          let #(column_index, acc) = acc

          let assert Ok(int) = decode_value(char)
          let coordinate = coordinate.new(row: row_index, column: column_index)

          #(column_index + 1, insert(acc, coordinate, int))
        })

      #(row_index + 1, acc)
    })
  map
}

pub fn reduce_surrounding(map, coordinate, initial, function) {
  coordinate
  |> coordinate.surrounding()
  |> list.filter(fn(coordinate) { in_bounds(map, coordinate) })
  |> list.fold(initial, fn(acc, coordinate) {
    let assert option.Some(value) = get(map, coordinate)
    function(acc, coordinate, value)
  })
}

pub fn in_bounds(map: Map(a), coordinate: Coordinate) {
  coordinate.row >= 0
  && coordinate.row < map.height
  && coordinate.column >= 0
  && coordinate.column < map.width
}

pub fn to_string(map, format) {
  reduce_safe(map, "", fn(acc, coordinate, item) {
    let char = format(item)

    let updated = acc <> char
    case coordinate.column == map.width - 1 {
      True -> updated <> "\n"
      False -> updated
    }
  })
}

pub fn insert(map, coordinate, value) {
  map
  |> map_dict(fn(dict) { dict.insert(dict, coordinate, value) })
  |> sync_size(coordinate)
}

pub fn get(map: Map(a), coordinate) {
  map.dict
  |> dict.get(coordinate)
  |> option.from_result()
}

fn sync_size(map, coordinate: Coordinate) {
  Map(
    ..map,
    width: int.max(coordinate.column + 1, map.width),
    height: int.max(coordinate.row + 1, map.height),
  )
}

pub fn reduce_safe(map: Map(a), initial, function) {
  tools.for(0, map.height, initial, fn(accumulator, row_index) {
    tools.for(0, map.width, accumulator, fn(accumulator, column_index) {
      let coordinate = coordinate.new(row: row_index, column: column_index)
      case dict.get(map.dict, coordinate) {
        Ok(value) -> function(accumulator, coordinate, value)
        _ -> accumulator
      }
    })
  })
}

pub fn add(map, coordinate, item) {
  map_dict(map, fn(dict) { dict.insert(dict, coordinate, item) })
}

fn map_dict(map, function) {
  Map(..map, dict: function(map.dict))
}
