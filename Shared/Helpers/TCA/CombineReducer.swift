import ComposableArchitecture


public struct CombineReducer<R1: ReducerProtocol, R2: ReducerProtocol>: ReducerProtocol
where R1.State == R2.State, R1.Action == R2.Action {
  public typealias State = R1.State
  public typealias Action = R1.Action

  let r1: R1
  let r2: R2

  public func reduce(state: inout State, action: Action) -> Effect<Action, Never> {
    let effects1 = r1.reduce(state: &state, action: action)
    let effects2 = r2.reduce(state: &state, action: action)
    return .merge(effects1, effects2)
  }
}


public extension ReducerProtocol {
  func combined<R2: ReducerProtocol>(with r2: R2) -> CombineReducer<Self, R2>
  where R2.State == State, R2.Action == Action {
    CombineReducer(r1: self, r2: r2)
  }

  func combined<R2: ReducerProtocol, R3: ReducerProtocol>
  (with r2: R2, _ r3: R3) -> CombineReducer<CombineReducer<Self, R2>, R3>
  where
  R2.State == State, R2.Action == Action,
  R3.State == State, R3.Action == Action
  {
    CombineReducer(
      r1: CombineReducer(r1: self, r2: r2),
      r2: r3
    )
  }

  func combined<
    R2: ReducerProtocol,
    R3: ReducerProtocol,
    R4: ReducerProtocol
  >(with r2: R2, _ r3: R3, _ r4: R4)
  -> CombineReducer<CombineReducer<Self, R2>, CombineReducer<R3, R4>>
  where
  R2.State == State, R2.Action == Action,
  R3.State == State, R3.Action == Action
  {
    CombineReducer(
      r1: CombineReducer(r1: self, r2: r2),
      r2: CombineReducer(r1: r3, r2: r4)
    )
  }

  func combined<
    R2: ReducerProtocol,
    R3: ReducerProtocol,
    R4: ReducerProtocol,
    R5: ReducerProtocol
  >(with r2: R2, _ r3: R3, _ r4: R4, _ r5: R5)
  -> CombineReducer<
    CombineReducer<CombineReducer<Self, R2>, R3>,
    CombineReducer<R4, R5>
  >
  where
  R2.State == State, R2.Action == Action,
  R3.State == State, R3.Action == Action
  {
    CombineReducer(
      r1: CombineReducer(r1: CombineReducer(r1: self, r2: r2), r2: r3),
      r2: CombineReducer(r1: r4, r2: r5)
    )
  }

  func combined<
    R2: ReducerProtocol,
    R3: ReducerProtocol,
    R4: ReducerProtocol,
    R5: ReducerProtocol,
    R6: ReducerProtocol
  >(with r2: R2, _ r3: R3, _ r4: R4, _ r5: R5, _ r6: R6)
  -> CombineReducer<
    CombineReducer<CombineReducer<Self, R2>, R3>,
    CombineReducer<R4, CombineReducer<R5, R6>>
  >
  where
  R2.State == State, R2.Action == Action,
  R3.State == State, R3.Action == Action
  {
    CombineReducer(
      r1: CombineReducer(r1: CombineReducer(r1: self, r2: r2), r2: r3),
      r2: CombineReducer(r1: r4, r2: CombineReducer(r1: r5, r2: r6))
    )
  }

  func combined<
    R2: ReducerProtocol,
    R3: ReducerProtocol,
    R4: ReducerProtocol,
    R5: ReducerProtocol,
    R6: ReducerProtocol,
    R7: ReducerProtocol
  >(with r2: R2, _ r3: R3, _ r4: R4, _ r5: R5, _ r6: R6, _ r7: R7)
  -> CombineReducer<
    CombineReducer<CombineReducer<Self, R2>, CombineReducer<R3, R4>>,
    CombineReducer<CombineReducer<R5, R6>, R7>
  >
  where
  R2.State == State, R2.Action == Action,
  R3.State == State, R3.Action == Action,
  R5.State == State, R5.Action == Action
  {
    CombineReducer(
      r1: CombineReducer(r1: CombineReducer(r1: self, r2: r2), r2: CombineReducer(r1: r3, r2: r4)),
      r2: CombineReducer(r1: CombineReducer(r1: r5, r2: r6), r2: r7)
    )
  }

  func combined<
    R2: ReducerProtocol,
    R3: ReducerProtocol,
    R4: ReducerProtocol,
    R5: ReducerProtocol,
    R6: ReducerProtocol,
    R7: ReducerProtocol,
    R8: ReducerProtocol
  >(with r2: R2, _ r3: R3, _ r4: R4, _ r5: R5, _ r6: R6, _ r7: R7, _ r8: R8)
  -> CombineReducer<
    CombineReducer<CombineReducer<Self, R2>, CombineReducer<R3, R4>>,
    CombineReducer<CombineReducer<R5, R6>, CombineReducer<R7, R8>>
  >
  where
  R2.State == State, R2.Action == Action,
  R3.State == State, R3.Action == Action,
  R5.State == State, R5.Action == Action
  {
    CombineReducer(
      r1: CombineReducer(r1: CombineReducer(r1: self, r2: r2), r2: CombineReducer(r1: r3, r2: r4)),
      r2: CombineReducer(r1: CombineReducer(r1: r5, r2: r6), r2: CombineReducer(r1: r7, r2: r8))
    )
  }
}
