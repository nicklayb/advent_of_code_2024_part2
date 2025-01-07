import argument.{First, Second}
import gleam/int
import gleam/io
import simplifile

const base_path = "./inputs/"

pub type Input {
  Input(argument.Part, String)
}

pub fn challenge(day, part_1, part_2) {
  let result = case load_input(day) {
    Input(First, content) -> part_1(content)
    Input(Second, content) -> part_2(content)
  }
  io.debug(result)
}

fn load_input(day) {
  let argument = argument.parse(day)
  let file_path = base_path <> input_file_path(argument)
  let assert Ok(content) = simplifile.read(file_path)
  Input(argument.get_part(argument), content)
}

fn input_file_path(argument) {
  case argument {
    argument.Main(day, _) -> int.to_string(day) <> "-main.txt"
    argument.Sample(day, _) -> int.to_string(day) <> "-sample.txt"
  }
}
