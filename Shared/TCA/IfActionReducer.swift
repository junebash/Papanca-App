import ComposableArchitecture


extension Reducers {
  public struct IfAction<State, Action, Value>: ReducerProtocol {
    let extract: (Action) -> Value?
    let response: (inout State, Value) -> Effect<Action, Never>

    public init(
      case extract: @escaping (Action) -> Value?,
      reduce response: @escaping (inout State, Value) -> Effect<Action, Never>
    ) {
      self.extract = extract
      self.response = response
    }

    public func reduce(state: inout State, action: Action) -> Effect<Action, Never> {
      extract(action)
        .map { response(&state, $0) }
      ?? .none
    }
  }
}

extension ReducerProtocol {
  static func ifAction<State, Action, Value>(
    _ extract: @escaping (Action) -> Value?,
    then response: @escaping (inout State, Value) -> Effect<Action, Never>
  ) -> Reducers.IfAction<State, Action, Value>
  where Self == Reducers.IfAction<State, Action, Value> {
    Reducers.IfAction(case: extract, reduce: response)
  }
}
