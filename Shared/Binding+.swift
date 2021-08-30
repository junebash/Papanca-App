import SwiftUI

extension Binding {
  public var optional: Binding<Value?> {
    .init(get: { wrappedValue }, set: { wrappedValue = $0 ?? wrappedValue })
  }

  public func optional(default: Value) -> Binding<Value?> {
    .init(get: { wrappedValue }, set: { wrappedValue = $0 ?? `default` })
  }

  public func coalescing<Wrapped>(
    get defaultValue: @escaping @autoclosure () -> Wrapped,
    set transform: @escaping (Wrapped) -> Wrapped?
  ) -> Binding<Wrapped> where Value == Wrapped? {
    .init(
      get: { wrappedValue ?? defaultValue() },
      set: { wrappedValue = transform($0) }
    )
  }
}
