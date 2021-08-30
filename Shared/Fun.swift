public func configure<T>(_ item: T, with apply: (inout T) -> Void) -> T {
  var item = item
  apply(&item)
  return item
}

public func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
  if let a = a, let b = b { return (a, b) }
  else { return nil }
}
