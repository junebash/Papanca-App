import ComposableArchitecture


@resultBuilder
public enum ReducerBuilder {
  public static func buildBlock<R: ReducerProtocol>(_ reducer: R) -> R {
    reducer
  }

  public static func buildBlock<R1, R2>(_ r1: R1, _ r2: R2) -> CombineReducer<R1, R2>
  where
    R1: ReducerProtocol, R2: ReducerProtocol,
    R1.State == R2.State, R1.Action == R2.Action
  {
    CombineReducer(r1: r1, r2: r2)
  }

  public static func buildBlock<R1, R2, R3>(_ r1: R1, _ r2: R2, _ r3: R3) -> CombineReducer<CombineReducer<R1, R2>, R3>
  where
    R1: ReducerProtocol, R2: ReducerProtocol, R3: ReducerProtocol,
    R1.State == R2.State, R1.Action == R2.Action, R3.State == R1.State, R3.Action == R1.Action
  {
    CombineReducer(r1: CombineReducer(r1: r1, r2: r2), r2: r3)
  }

  public static func buildBlock<R1, R2, R3, R4>(_ r1: R1, _ r2: R2, _ r3: R3, _ r4: R4
  ) -> CombineReducer<CombineReducer<R1, R2>, CombineReducer<R3, R4>>
  where
    R1: ReducerProtocol, R2: ReducerProtocol, R3: ReducerProtocol, R4: ReducerProtocol,
    R1.State == R2.State, R1.Action == R2.Action,
    R3.State == R1.State, R3.Action == R1.Action
  {
    CombineReducer(r1: CombineReducer(r1: r1, r2: r2), r2: CombineReducer(r1: r3, r2: r4))
  }

  public static func buildFinalResult<R: ReducerProtocol>(_ component: R) -> AnyReducer<R.State, R.Action> {
    component.eraseToAnyReducer()
  }
}
