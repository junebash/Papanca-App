public struct EquatableError: Error, Equatable {
  public let upstream: Error

  private let isEqualTo: (Error) -> Bool

  public init<E: Error & Equatable>(_ error: E) {
    self.upstream = error
    self.isEqualTo = { error == $0 as? E }
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.isEqualTo(rhs.upstream)
  }
}
