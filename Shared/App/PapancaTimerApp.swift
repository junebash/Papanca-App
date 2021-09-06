import ComposableArchitecture
import SwiftUI


public class AppDelegate: UIResponder, UIApplicationDelegate {
  let store: Store<AppState, AppAction> = Store(
    initialState: AppState(),
    reducer: AppReducer.live()
  )

  private(set) lazy var viewStore = ViewStore(
    store.scope(state: { _ in () }, action: AppAction.system),
    removeDuplicates: ==
  )
}

@main
struct PapancaTimerApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @Environment(\.scenePhase) var scenePhase
  @Environment(\.colorScheme) var colorScheme

  var viewStore: ViewStore<(), SystemAction> {
    appDelegate.viewStore
  }

  var body: some Scene {
    WindowGroup {
      ContentView(store: appDelegate.store)
    }
    .onChange(of: scenePhase) {
      viewStore.send(SystemAction(scenePhase: $0, colorScheme: colorScheme))
    }
  }
}

