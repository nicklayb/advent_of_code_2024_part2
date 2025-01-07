pub fn for(initial, maximum, accumulator, function) {
  case initial == maximum {
    True -> accumulator
    False -> {
      for(initial + 1, maximum, function(accumulator, initial), function)
    }
  }
}

pub fn tap(value, function) {
  function(value)
  value
}
