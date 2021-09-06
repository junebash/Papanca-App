import ComposableArchitecture

extension Reducers {
  public struct Binding<Upstream: ReducerProtocol>: ReducerProtocol
  where Upstream.Action: BindableAction, Upstream.Action.State == Upstream.State {
    public typealias State = Upstream.State
    public typealias Action = Upstream.Action

    let reducer: AnyReducer<State, Action>

    init(upstream: Upstream) {
      reducer = upstream.eraseToAnyReducer().binding(action: /Action.binding)
    }

    public func reduce(state: inout Upstream.State, action: Upstream.Action) -> Effect<Upstream.Action, Never> {
      // TODO: recreate
      reducer.reduce(state: &state, action: action)
    }
  }
}

extension ReducerProtocol {
  func binding() -> Reducers.Binding<Self>
  where Action: BindableAction, Action.State == State {
    Reducers.Binding(upstream: self)
  }
}
