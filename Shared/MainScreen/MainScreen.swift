import SwiftUI
import ComposableArchitecture


public struct MainScreen: View {
  private struct Option<State: Equatable, Action, Content: View>: View {
    private struct ViewState: Equatable {
      var showButton: Bool
      var showContent: Bool

      init(
        screen: AppState.Screen,
        casePath: CasePath<AppState.Screen, State>
      ) {
        showButton = casePath ~= screen || screen == .main
        showContent = casePath ~= screen
      }
    }
    private let title: String
    private let casePath: CasePath<AppState.Screen, State>
    private let store: Store<AppState, AppAction>
    private let content: (Store<State, Action>) -> Content
    private let action: (Action) -> AppAction

    @ObservedObject private var dispatch: ViewStore<ViewState, Bool>

    init(
      title: String,
      store: Store<AppState, AppAction>,
      casePath: CasePath<AppState.Screen, State>,
      action: @escaping (Action) -> AppAction,
      expand: @escaping (Bool) -> Action,
      content: @escaping (Store<State, Action>) -> Content
    ) {
      self.title = title
      self.store = store
      self.casePath = casePath
      self.content = content
      self.action = action
      self.dispatch = ViewStore(store.scope(
        state: { ViewState(screen: $0.screen, casePath: casePath) },
        action: { action(expand($0)) }
      ))
    }

    var body: some View {
      if dispatch.showButton {
        ExpandableStoreField(store: store.scope(
          state: { casePath.extract(from: $0.screen) },
          action: action
        )) { localStore in
          content(localStore)
            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300)
        } label: {
          Text(title)
            .onTapGesture {
              dispatch.send(!dispatch.showContent)
            }
            .frame(maxWidth: .infinity)
        }
        .compositingGroup()
      }
    }
  }

  let store: Store<AppState, AppAction>
  // TODO: Optimize; make 'viewState'/'viewAction' that only has required stuff
  @ObservedObject var viewStore: ViewStore<AppState, AppAction>

  public init(_ store: Store<AppState, AppAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  public var body: some View {
    VStack(spacing: 20) {
      Option(
        title: "Quick Timer",
        store: store,
        casePath: /AppState.Screen.quickTimer,
        action: AppAction.quickTimer,
        expand: QuickTimerAction.setShowing(_:),
        content: QuickTimerSetupView.init
      )

      Option(
        title: "Custom Timer",
        store: store,
        casePath: /AppState.Screen.customTimer,
        action: AppAction.customTimer,
        expand: TimerSetupAction.setShowing(_:),
        content: TimerSetupView.init
      )

      Option(
        title: "Presets",
        store: store,
        casePath: /AppState.Screen.presets,
        action: AppAction.presets,
        expand: { _ in .temp },
        content: { _ in EmptyView() }
      )

      Option(
        title: "Stats",
        store: store,
        casePath: /AppState.Screen.stats,
        action: AppAction.stats,
        expand: { _ in .temp },
        content: { _ in EmptyView() }
      )

      Option(
        title: "Settings",
        store: store,
        casePath: /AppState.Screen.settings,
        action: AppAction.settings,
        expand: { _ in .temp },
        content: { _ in EmptyView() }
      )
    }
    .shadow(radius: 5)
    .fixedSize(horizontal: true, vertical: false)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      ZStack {
        PapancaBackground(gradient: viewStore.system.colorPalette.papancaBGGradient)

        Group {
          if !(/AppState.Screen.main ~= viewStore.screen) {
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
    MainScreen(Store(initialState: .init(), reducer: AppReducer(preferences: TempPreferencesClient())))
  }
}
