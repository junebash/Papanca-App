import ComposableArchitecture


public enum TimerMode: String, Hashable, CaseIterable {
  case infinite = "Infinite", countdown = "Countdown"
}

public enum TimerChimeMode: String, Hashable, CaseIterable {
  case off = "Off", constant = "Constant", random = "Random"
}


public struct TimerSetupState: Equatable {
  public var timerMode: TimerMode
  public var timerSeconds: Double
  public var chimeMode: TimerChimeMode
  public var chimeMinimumSeconds: Double
  public var chimeMaximumSeconds: Double

  public var showTimerTime: Bool { timerMode == .countdown }
  public var showChimeMinimum: Bool { chimeMode == .constant || chimeMode == .random }
  public var showChimeMaximum: Bool { chimeMode == .random }
  public var chimeTitle: String { chimeMode == .constant ? "Interval" : "Minimum" }

  public init(
    timerMode: TimerMode = .infinite,
    timerSeconds: Double = 0.0,
    chimeMode: TimerChimeMode = .off,
    chimeMinimumSeconds: Double = 0.0,
    chimeMaximumSeconds: Double = 0.0
  ) {
    self.timerMode = timerMode
    self.timerSeconds = timerSeconds
    self.chimeMode = chimeMode
    self.chimeMinimumSeconds = chimeMinimumSeconds
    self.chimeMaximumSeconds = chimeMaximumSeconds
  }
}


public enum TimerSetupAction: Equatable, BindableAction {
  case binding(BindingAction<TimerSetupState>)
  case show
  case dismiss

  static func setShowing(_ willShow: Bool) -> Self {
    willShow ? .show : .dismiss
  }
}


public struct TimerSetupReducer: ReducerProtocol {
  public func reduce(state: inout TimerSetupState, action: TimerSetupAction) -> Effect<TimerSetupAction, Never> {
    return .none
  }
}
