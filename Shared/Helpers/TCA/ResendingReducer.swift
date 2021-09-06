import ComposableArchitecture

extension Reducers {
  public struct Resending<Upstream: ReducerProtocol>: ReducerProtocol {
    public typealias State = Upstream.State
    public typealias Action = Upstream.Action

    let upstream: Upstream
    let transform: (Action) -> Action?

    public func reduce(state: inout State, action: Action) -> Effect<Action, Never> {
      transform(action).map {
        upstream.reduce(state: &state, action: $0)
      } ?? .none
    }
  }
}

extension ReducerProtocol {
  public func resending(_ transform: @escaping (Action) -> Action?) -> Reducers.Resending<Self> {
    Reducers.Resending(upstream: self, transform: transform)
  }

  public func resending(_ input: Action, as output: Action) -> Reducers.Resending<Self>
  where Action: Equatable {
    Reducers.Resending(upstream: self) { $0 == input ? output : nil }
  }
}
