import ComposableArchitecture


public struct SimpleReducer<State, Action>: ReducerProtocol {
  let transform: (Action) -> State?

  public init(_ reduce: @escaping (Action) -> State?) {
    self.transform = reduce
  }

  public func reduce(state: inout State, action: Action) -> Effect<Action, Never> {
    if let newState = transform(action) {
      state = newState
    }
    return .none
  }
}
