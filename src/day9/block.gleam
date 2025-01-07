import day9/sequence
import gleam/int
import gleam/list
import indexed_array
import tools

pub type ID =
  Int

pub type Length =
  Int

pub type Chunk {
  DataChunk(ID, Length)
  FreeChunk(Length)
}

pub type Block {
  Free
  Data(ID)
}

pub fn blocks_to_string(blocks) {
  indexed_array.reduce(blocks, "", fn(acc, _, block) {
    acc <> block_to_string(block)
  })
}

pub fn has_free_block(blocks) {
  indexed_array.any(blocks, fn(_, _, item) {
    case item {
      Free -> True
      _ -> False
    }
  })
}

fn block_to_string(block) {
  case block {
    Free -> "[ ]"
    Data(id) -> "[" <> int.to_string(id) <> "]"
  }
}

pub fn decode_data(string, sequence) {
  let assert Ok(int) = int.parse(string)
  new_data(int, sequence)
}

pub fn decode_free(string) {
  let assert Ok(int) = int.parse(string)
  new_free(int)
}

fn new_data(length, sequence) {
  let #(new_id, new_sequence) = sequence.next(sequence)
  #(DataChunk(new_id, length), new_sequence)
}

fn new_free(length) {
  FreeChunk(length)
}

pub fn to_block(blocks) {
  list.fold(blocks, indexed_array.new(), fn(acc, block) {
    case block {
      DataChunk(id, length) ->
        tools.for(0, length, acc, fn(acc, _) {
          indexed_array.push(acc, Data(id))
        })
      FreeChunk(length) ->
        tools.for(0, length, acc, fn(acc, _) { indexed_array.push(acc, Free) })
    }
  })
}
