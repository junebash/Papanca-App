import ComposableArchitecture
import SwiftUI


public struct AppState: Equatable {
  public enum Screen: Equatable {
    case main
    case quickTimer(QuickTimerState)
    case customTimer(TimerSetupState)
    case presets(PresetsState)
    case settings(SettingsState)
    case stats(StatsState)

    public func show<CaseValue>(_ screen: CasePath<Screen, CaseValue>) -> Bool {
      if case .main = self { return true }
      else { return screen ~= self }
    }
  }

  public var screen: Screen = .main
  public var system: SystemState = .init()

  public var quickTimer: QuickTimerState? {
    (/Screen.quickTimer).extract(from: screen)
  }

  public var customTimer: TimerSetupState? {
    (/Screen.customTimer).extract(from: screen)
  }
}


public enum AppAction: Equatable {
  case quickTimer(QuickTimerAction)
  case customTimer(TimerSetupAction)
  case system(SystemAction)
  case presets(PresetsAction)
  case stats(StatsAction)
  case settings(SettingsAction)
}


public struct AppReducer: ReducerProtocol {
  public typealias State = AppState
  public typealias Action = AppAction

  private let upstream: AnyReducer<AppState, AppAction>

  public init(preferences: UserPreferencesClient) {
    let screenCoreReducer = SimpleReducer<AppState.Screen, AppAction> {
      switch $0 {
      case .quickTimer(.show):
        return .quickTimer(QuickTimerState())
      case .customTimer(.show):
        return .customTimer(TimerSetupState())
      case .quickTimer(.dismiss), .customTimer(.dismiss):
        return .main
      default:
        return nil
      }
    }
    let screenReducer = screenCoreReducer.combined(
      with: QuickTimerReducer()
        .pullback(
          state: /AppState.Screen.quickTimer,
          action: /AppAction.quickTimer
        ),
      TimerSetupReducer()
        .binding()
        .pullback(
          state: /AppState.Screen.customTimer,
          action: /AppAction.customTimer
        ),
      PresetsReducer()
        .pullback(
          state: /AppState.Screen.presets,
          action: /AppAction.presets
        ),
      StatsReducer()
        .pullback(
          state: /AppState.Screen.stats,
          action: /AppAction.stats
        ),
      SettingsReducer()
        .pullback(
          state: /AppState.Screen.settings,
          action: /AppAction.settings
        )
    )
    self.upstream = SystemReducer(preferencesClient: preferences)
      .pullback(state: \AppState.system, action: /AppAction.system)
      .combined(with: screenReducer.pullback(state: \AppState.screen))
      .eraseToAnyReducer()
      .debug()
  }

  static func live() -> AppReducer {
    AppReducer(preferences: TempPreferencesClient())
  }

  public func reduce(state: inout AppState, action: AppAction) -> Effect<AppAction, Never> {
    upstream.reduce(state: &state, action: action)
  }
}
