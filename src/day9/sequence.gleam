pub type Sequence {
  Sequence(Int)
}

pub fn new(initial) {
  Sequence(initial)
}

pub fn next(sequence) {
  case sequence {
    Sequence(current) -> #(current, Sequence(current + 1))
  }
}
