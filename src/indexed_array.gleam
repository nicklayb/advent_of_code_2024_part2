import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}

pub type IndexedArray(value) {
  Array(length: Int, dict: Dict(Int, value))
}

pub fn from_list(list) {
  list.fold(list, new(), push)
}

pub fn new() {
  Array(length: 0, dict: dict.new())
}

pub fn push(array, item) {
  let #(new_array, index) = next_index(array)

  Array(..new_array, dict: dict.insert(array.dict, index, item))
}

pub fn push_all(array, items) {
  list.fold(items, array, push)
}

pub fn map(array, function) {
  reduce(array, array, fn(accumulator, index, item) {
    let assert Some(updated_array) =
      put(accumulator, index, function(index, item))
    updated_array
  })
}

pub fn reduce(array, initial, function) {
  reduce_while(array, 0, initial, fn(acc, index, item) {
    list.Continue(function(acc, index, item))
  })
}

pub fn reduce_while(array, from, initial, function) {
  internal_reduce(array, from, initial, function)
}

fn internal_reduce(array: IndexedArray(v), current_index, accumulator, function) {
  case current_index < array.length {
    True -> {
      let assert Some(item) = get(array, current_index)
      case function(accumulator, current_index, item) {
        list.Continue(new_accumulator) ->
          internal_reduce(array, current_index + 1, new_accumulator, function)
        list.Stop(new_accumulator) -> new_accumulator
      }
    }
    False -> accumulator
  }
}

pub fn pop(array: IndexedArray(v)) {
  array
  |> get_last()
  |> option.map(fn(last_item) {
    #(
      last_item,
      Array(
        length: array.length - 1,
        dict: dict.delete(array.dict, array.length),
      ),
    )
  })
}

pub fn get_last(array: IndexedArray(v)) {
  get(array, array.length - 1)
}

pub fn get(array: IndexedArray(v), index) {
  array.dict
  |> dict.get(index)
  |> option.from_result()
}

pub fn put(array, index, item) {
  case has_index(array, index) {
    True -> Some(Array(..array, dict: dict.insert(array.dict, index, item)))
    False -> None
  }
}

pub fn has_index(array: IndexedArray(v), index) {
  array.length > 0 && index < array.length
}

pub fn swap(array: IndexedArray(v), left, right) {
  case get(array, left), get(array, right) {
    Some(left_item), Some(right_item) ->
      array
      |> put(right, left_item)
      |> option.map(fn(new_array) { put(new_array, left, right_item) })

    _, _ -> None
  }
}

pub fn any(array, function) {
  reduce_while(array, 0, False, fn(acc, index, item) {
    case function(acc, index, item) {
      True -> list.Stop(True)
      False -> list.Continue(False)
    }
  })
}

fn next_index(array) {
  #(Array(..array, length: array.length + 1), array.length)
}
