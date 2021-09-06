import ComposableArchitecture


extension Reducers {
  public struct Empty<State, Action>: ReducerProtocol {
    public init() {}

    public func reduce(state: inout State, action: Action) -> Effect<Action, Never> {
      return .none
    }
  }
}


extension ReducerProtocol {
  public static func empty<State, Action>() -> Reducers.Empty<State, Action>
  where Self == Reducers.Empty<State, Action> {
    Reducers.Empty()
  }
}
