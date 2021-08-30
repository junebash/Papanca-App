import SwiftUI
import ComposableArchitecture

public struct AppState: Equatable {
  public enum Screen: Equatable {
    case main
    case quickTimer(QuickTimerState)
    case customTimer(TimerSetupState)

    var isMain: Bool {
      if case .main = self { return true } else { return false }
    }

    var isQuickTimer: Bool {
      if case .quickTimer = self { return true } else { return false }
    }

    var showCustomTimer: Bool {
      switch self {
      case .main, .customTimer: return true
      default: return false
      }
    }

    func show<CaseValue: Equatable>(_ screen: CasePath<Screen, CaseValue>) -> Bool {
      if case .main = self { return true }
      else { return screen.extract(from: self).isNil.isFalse }
    }

    func `is`<CaseValue: Equatable>(_ screen: CasePath<Screen, CaseValue>) -> Bool {
      screen.extract(from: self).isNil.isFalse
    }
  }

  public var hourOfDay: Int
  public var screen: Screen = .main

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
}


public struct MainScreen: View {
  let store: Store<AppState, AppAction>
  @ObservedObject var viewStore: ViewStore<AppState, AppAction>

  public init(_ store: Store<AppState, AppAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  public var body: some View {
    VStack(spacing: 20) {
      TitledExpandableField(
        title: "Quick Timer",
        selection: "nil",
        showingContent: viewStore.binding(
          get: { $0.screen.is(/AppState.Screen.quickTimer)},
          send: { .quickTimer($0 ? .show : .dismiss) }
        )
      ) {
        IfLetStore(store.scope(
          state: \.quickTimer,
          action: { .quickTimer($0) }
        )) { quickTimerStore in
          QuickTimerSetupView(store: quickTimerStore)
        }
      }
      .placeholderColor(.blue)
      .compositingGroup()
      .shadow(radius: 5)

      if viewStore.screen.showCustomTimer {
        Group {
          Button(action: {}) {
            Text("Custom Timer")
              .frame(maxWidth: .infinity)
          }
          .sheet(
            isPresented: viewStore.binding(
              get: { $0.screen.is(/AppState.Screen.customTimer) },
              send: { .customTimer($0 ? .show : .dismiss) }
            ),
            onDismiss: viewStore.willSend(.customTimer(.dismiss)),
            content: {
              IfLetStore(store.scope(
                state: \.customTimer,
                action: AppAction.customTimer
              )) { customTimerSetupStore in
                TimerSetupView(store: customTimerSetupStore)
              }
            }
          )

          Button(action: {}) {
            Text("Presets")
              .frame(maxWidth: .infinity)
          }

          Button(action: {}) {
            Text("Stats & Settings")
              .frame(maxWidth: .infinity)
          }
        }
        .buttonStyle(.papanca)
      }
    }
    .frame(maxHeight: 400)
    .fixedSize(horizontal: true, vertical: false)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      ZStack {
        PapancaBackground(hourOfDay: viewStore.hourOfDay)

        Group {
          if !viewStore.screen.isMain {
            Color.clear.background(.thinMaterial, ignoresSafeAreaEdges: .all)
          }
        }
      }
    }
    .animation(.default, value: viewStore.state)
  }
}


enum MainScreen_Previews: PreviewProvider {
  static var previews: some View {
//    MainScreen()
    EmptyView()
  }
}
