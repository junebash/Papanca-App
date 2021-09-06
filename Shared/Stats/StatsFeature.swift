import ComposableArchitecture


public struct StatsState: Equatable {}


public enum StatsAction: Equatable {
  case temp
}


public struct StatsReducer: ReducerProtocol {
  public func reduce(state: inout StatsState, action: StatsAction) -> Effect<StatsAction, Never> {
    // TODO
    .none
  }
}
