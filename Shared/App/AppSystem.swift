import Combine
import ComposableArchitecture
import SwiftUI


public enum SystemAction: Equatable {
//  case didFinishLaunching
  case didEnterBackground
  case didBecomeInactive
  case didBecomeActive(ColorScheme)
  case preferencesDidLoad(Result<UserPreferences, UserPreferencesError>)

  init(scenePhase: ScenePhase, colorScheme: ColorScheme) {
    switch scenePhase {
    case .active:
      self = .didBecomeActive(colorScheme)
    case .background:
      self = .didEnterBackground
    case .inactive:
      self = .didBecomeInactive
    @unknown default:
      preconditionFailure("Unhandled scene phase(s)")
    }
  }
}


public struct SystemState: Equatable {
  public var colorPalette: ColorPalette = .day
  public var userPreferences: UserPreferences = .init()
}


public struct SystemReducer: ReducerProtocol {
  let preferencesClient: UserPreferencesClient

  public func reduce(state: inout SystemState, action: SystemAction) -> Effect<SystemAction, Never> {
    switch action {
    case .didBecomeActive(let colorScheme):
      state.colorPalette = state.userPreferences.colorPalette.colorPalette(for: colorScheme)
      return .async {
        await .preferencesDidLoad(preferencesClient.loadUserPreferences())
      }

    case .didEnterBackground:
      return .none

    case .didBecomeInactive:
      return .none

    case .preferencesDidLoad(.success(let preferences)):
      state.userPreferences = preferences
      return .none

    case .preferencesDidLoad(.failure(_)):
      // todo
      return .none
    }
  }
}
