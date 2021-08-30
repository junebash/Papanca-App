import SwiftUI
import ComposableArchitecture


private extension TimerState {
  var featureViewState: TimerFeatureView.ViewState {
    .init(displayTime: displayTime, isPaused: isPaused)
  }
}


struct TimerFeatureView: View {
  struct ViewState: Equatable {
    var displayTime: Double
    var isPaused: Bool
  }

  enum ViewAction: Equatable {
    case finish
    case setPaused(Bool)
    case onAppear

    fileprivate var timerAction: TimerAction {
      switch self {
      case .finish: return .finish
      case .setPaused(let willPause): return .setPaused(willPause)
      case .onAppear: return .startInitialTimer
      }
    }
  }

  let store: Store<TimerState, TimerAction>

  var body: some View {
    WithViewStore(store.scope(
      state: \.featureViewState,
      action: \.timerAction
    )) { (viewStore: ViewStore<ViewState, ViewAction>) in
      TimerView(
        timeRemaining: viewStore.displayTime,
        isPaused: viewStore.binding(get: \.isPaused, send: ViewAction.setPaused),
        finish: viewStore.willSend(.finish)
      ).onAppear(perform: viewStore.willSend(.onAppear))
    }
  }
}
