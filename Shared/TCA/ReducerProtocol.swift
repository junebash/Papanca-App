import ComposableArchitecture


public protocol ReducerProtocol {
  associatedtype State
  associatedtype Action

  func reduce(state: inout State, action: Action) -> Effect<Action, Never>
}


extension ReducerProtocol {
  public func eraseToAnyReducer() -> AnyReducer<State, Action> {
    .init { state, action, _ in reduce(state: &state, action: action) }
  }
}


public typealias AnyReducer<State, Action> = Reducer<State, Action, Void>


extension Reducer: ReducerProtocol where Environment == Void {
  public func reduce(state: inout State, action: Action) -> Effect<Action, Never> {
    self.run(&state, action, ())
  }
}


public enum Reducers {}


extension Store {
  public convenience init<R: ReducerProtocol>(
    initialState: State,
    reducer: R
  ) where R.State == State, R.Action == Action {
    self.init(initialState: initialState, reducer: reducer.eraseToAnyReducer(), environment: ())
  }
}

public typealias StoreOf<R: ReducerProtocol> = Store<R.State, R.Action>
