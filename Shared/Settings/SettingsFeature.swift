import ComposableArchitecture


public struct SettingsState: Equatable {}


public enum SettingsAction: Equatable {
  case temp
}


public struct SettingsReducer: ReducerProtocol {
  public func reduce(state: inout SettingsState, action: SettingsAction) -> Effect<SettingsAction, Never> {
    // TODO
    .none
  }
}

