extension Optional {
  var isNil: Bool {
    switch self {
    case .none:
      return true
    case .some:
      return false
    }
  }
}

extension Bool {
  var isFalse: Bool { !self }
}
