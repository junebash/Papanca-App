public func configure<T>(_ item: T, with apply: (inout T) -> Void) -> T {
  var item = item
  apply(&item)
  return item
}

public func zip<A, B>(_ a: A?, _ b: B?) -> (A, B)? {
  if let a = a, let b = b { return (a, b) }
  else { return nil }
}

public func absurd<T>(_: Never) -> T {}

public func always<In, Out>(_ out: Out) -> (In) -> Out {
  { _ in out }
}

public func void<T>(_: T) -> Void {}
