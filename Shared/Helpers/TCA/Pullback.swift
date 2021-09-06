import ComposableArchitecture


extension Reducers {
  public struct Pullback<LocalReducer, StatePath, ActionPath>: ReducerProtocol
  where
    LocalReducer: ReducerProtocol,
    StatePath: WritablePath,
    ActionPath: WritablePath,
    StatePath.Value == LocalReducer.State,
    ActionPath.Value == LocalReducer.Action
  {
    let localReducer: LocalReducer
    let toLocalState: StatePath
    let toLocalAction: ActionPath

    public func reduce(state: inout StatePath.Root, action: ActionPath.Root) -> Effect<ActionPath.Root, Never> {
      guard
        let localAction = toLocalAction.extract(from: action),
        var localState = toLocalState.extract(from: state)
      else {
        return .none
      }

      let localEffects = localReducer.reduce(state: &localState, action: localAction)
      toLocalState.embed(localState, in: &state)
      return localEffects.map { toLocalAction.embedded($0, in: action) }
    }
  }
}

extension ReducerProtocol {
  public func pullback<StatePath: WritablePath, ActionPath: WritablePath>(
    state toLocalState: StatePath,
    action toLocalAction: ActionPath
  ) -> Reducers.Pullback<Self, StatePath, ActionPath> {
    .init(localReducer: self, toLocalState: toLocalState, toLocalAction: toLocalAction)
  }

  public func pullback<StatePath: WritablePath>(
    state toLocalState: StatePath
  ) -> Reducers.Pullback<Self, StatePath, ConstantPath<Action>> {
    .init(localReducer: self, toLocalState: toLocalState, toLocalAction: ConstantPath())
  }

  public func pullback<ActionPath: WritablePath>(
    action toLocalAction: ActionPath
  ) -> Reducers.Pullback<Self, ConstantPath<State>, ActionPath> {
    .init(localReducer: self, toLocalState: ConstantPath(), toLocalAction: toLocalAction)
  }
}
