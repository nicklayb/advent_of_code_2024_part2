import day9/block
import day9/sequence
import gleam/list
import gleam/option
import gleam/string
import indexed_array
import input

pub fn main() {
  input.challenge(9, part_1, part_2)
}

fn part_1(content) {
  let sequence = sequence.new(0)

  let blocks =
    content
    |> string.trim()
    |> string.split("")
    |> decode_diskmap(sequence, [])
    |> block.to_block()

  blocks
  |> trim_sequence()
  |> reorganize(0)
  |> checksum()
}

fn reorganize(block_sequence, index) {
  let free_index =
    indexed_array.reduce_while(
      block_sequence,
      index,
      option.None,
      fn(_, index, item) {
        case item {
          block.Free -> list.Stop(option.Some(index))
          _ -> list.Continue(option.None)
        }
      },
    )

  case free_index {
    option.None -> block_sequence
    option.Some(index) -> {
      let assert option.Some(#(popped_item, updated_array)) =
        indexed_array.pop(block_sequence)
      let assert option.Some(array) =
        indexed_array.put(updated_array, index, popped_item)
      array
      |> trim_sequence()
      |> reorganize(index)
    }
  }
}

fn trim_sequence(block_sequence) {
  case indexed_array.pop(block_sequence) {
    option.Some(#(block.Free, new_sequence)) -> trim_sequence(new_sequence)
    _ -> block_sequence
  }
}

fn checksum(block_sequence) {
  indexed_array.reduce(block_sequence, 0, fn(acc, index, item) {
    case item {
      block.Data(id) -> acc + { index * id }
      _ -> acc
    }
  })
}

fn decode_diskmap(diskmap, sequence, accumulator) {
  case diskmap {
    [block_count, free_count, ..rest] -> {
      let #(block_chunk, new_sequence) =
        block.decode_data(block_count, sequence)
      let free_chunk = block.decode_free(free_count)
      decode_diskmap(rest, new_sequence, [
        free_chunk,
        block_chunk,
        ..accumulator
      ])
    }
    [block_count] -> {
      let #(block_chunk, new_sequence) =
        block.decode_data(block_count, sequence)
      decode_diskmap([], new_sequence, [block_chunk, ..accumulator])
    }
    [] -> list.reverse(accumulator)
  }
}

fn part_2(_content) {
  0
}
