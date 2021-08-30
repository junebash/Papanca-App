import ComposableArchitecture

public struct TimerState: Equatable {
  public enum Mode: Equatable {
    case countUp, countDown(total: TimeInterval)
  }

  public struct Time: Equatable {
    public private(set) var start: Date
    public var current: Date

    public init(start: Date, current: Date) {
      self.start = start
      self.current = current
    }

    public mutating func coalesceFromPaused(with next: Date) {
      let pauseTime = next.timeIntervalSince(self.current)
      self = Time(
        start: start.addingTimeInterval(pauseTime),
        current: current.addingTimeInterval(pauseTime)
      )
    }
  }

  public let mode: Mode
  public var actualStart: Date
  public var time: Time
  public var isPaused: Bool

  private var timeElapsed: Double {
    time.current.timeIntervalSince(time.start)
  }

  public var displayTime: Double {
    switch mode {
    case .countUp:
      return timeElapsed
    case .countDown(let total):
      return total - timeElapsed
    }
  }

  public init(
    mode: TimerState.Mode = .countUp,
    actualStart: Date = .now,
    time: TimerState.Time = .init(start: .now, current: .now),
    isPaused: Bool = false
  ) {
    self.mode = mode
    self.actualStart = actualStart
    self.time = time
    self.isPaused = isPaused
  }
}


public enum TimerAction: Equatable {
  case startInitialTimer
  case timerTick(Date)
  case finish
  case setPaused(Bool)
}


public struct TimerEnvironment {
  let mainRunLoop: AnySchedulerOf<RunLoop>
  let now: () -> Date
}


public let timerReducer = Reducer<
  TimerState,
  TimerAction,
  TimerEnvironment
> { state, action, environment in
  struct TimerCancelID: Hashable {}

  func startTimer() -> Effect<TimerAction, Never> {
    Effect.timer(
      id: TimerCancelID(),
      every: .init(1.0 / 10.0),
      on: environment.mainRunLoop
    ).map { .timerTick($0.date) }
  }

  switch action {
  case .startInitialTimer:
    let now = environment.now()
    state.actualStart = now
    state.time = .init(start: now, current: now)
    return startTimer()

  case .timerTick(let newDate):
    guard !state.isPaused else { return .none }
    state.time.current = newDate
    return .none

  case .setPaused(true), .finish:
    state.isPaused = true
    return .cancel(id: TimerCancelID())

  case .setPaused(false):
    state.isPaused = false
    state.time.coalesceFromPaused(with: environment.now())
    return startTimer()
  }
}
