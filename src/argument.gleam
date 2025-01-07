import argv

pub type Part {
  First
  Second
}

pub type Argument {
  Main(Int, Part)
  Sample(Int, Part)
}

pub fn parse(day) {
  let arguments = argv.load().arguments
  let part = parse_part(arguments)
  parse_file_type_argument(arguments, day, part)
}

pub fn get_part(argument) {
  case argument {
    Main(_, part) -> part
    Sample(_, part) -> part
  }
}

fn parse_file_type_argument(arguments, day, part) {
  case arguments {
    ["--sample", ..] -> Sample(day, part)
    [_, ..rest] -> parse_file_type_argument(rest, day, part)
    [] -> Main(day, part)
  }
}

fn parse_part(arguments) {
  case arguments {
    ["--part2", ..] -> Second
    [_, ..rest] -> parse_part(rest)
    [] -> First
  }
}
