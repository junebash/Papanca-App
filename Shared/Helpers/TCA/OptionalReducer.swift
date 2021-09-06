import ComposableArchitecture

extension Reducers {
  public struct Optional<Upstream: ReducerProtocol, WrappedState, WrappedAction>: ReducerProtocol
  where Upstream.State == WrappedState?, Upstream.Action == WrappedAction? {
    let upstream: Upstream
    let assertNonNil: Bool

    public func reduce(state: inout WrappedState, action: WrappedAction) -> Effect<WrappedAction, Never> {
      var optionalState: State? = state
      let effects = upstream.reduce(state: &optionalState, action: action)
        .compactMap { $0 }
        .eraseToEffect()
      guard let changedState = optionalState else {
        if assertNonNil {
          assertionFailure()
        }
        return effects
      }
      state = changedState
      return effects
    }
  }
}

extension ReducerProtocol {
  func optional<WrappedState, WrappedAction>(
    assertNonNil: Bool = true
  ) -> Reducers.Optional<Self, WrappedState, WrappedAction>
  where State == WrappedState?, Action == WrappedAction? {
    Reducers.Optional(upstream: self, assertNonNil: assertNonNil)
  }
}
