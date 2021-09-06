import ComposableArchitecture


public struct PresetsState: Equatable {}


public enum PresetsAction: Equatable {
  case temp
}


public struct PresetsReducer: ReducerProtocol {
  public func reduce(state: inout PresetsState, action: PresetsAction) -> Effect<PresetsAction, Never> {
    // TODO
    .none
  }
}
