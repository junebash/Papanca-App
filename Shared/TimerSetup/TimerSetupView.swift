import SwiftUI
import ComposableArchitecture


public struct TimerSetupView: View {
  let store: Store<TimerSetupState, TimerSetupAction>

  public struct LocalState: Equatable {
    public var showingTime = false
    public var showingChimeMinPicker = false
    public var showingChimeMaxPicker = false
  }

  @State public var localState: LocalState = .init()

  public var body: some View {
    Form {
      WithViewStore(store) { viewStore in
        Section {
          OptionSelector(
            title: "Timer Mode",
            selected: viewStore.binding(to: \.timerMode)
              .animation(),
            optionTitle: \.rawValue
          )
          if viewStore.showTimerTime {
            picker(
              title: "Time",
              time: viewStore.binding(to: \.timerSeconds),
              showing: $localState.showingTime
            )
          }
        } header: {
          Text("Timer Mode")
        }

        Section {
          OptionSelector(
            title: "Chimes",
            selected: viewStore.binding(to: \.chimeMode)
              .animation(),
            optionTitle: \.rawValue
          )

          if viewStore.showChimeMinimum {
            picker(
              title: viewStore.chimeTitle,
              time: viewStore.binding(to: \.chimeMinimumSeconds),
              showing: $localState.showingChimeMinPicker
            )
          }
          if viewStore.showChimeMaximum {
            picker(
              title: "Maximum",
              time: viewStore.binding(to: \.chimeMaximumSeconds),
              showing: $localState.showingChimeMaxPicker
            )
          }
        } header: {
          Text("Chimes")
        }
      }
    }
    .navigationTitle("Timer Setup")
    .navigationBarTitleDisplayMode(.inline)
  }

  @ViewBuilder
  private func picker(title: String, time: Binding<Double>, showing: Binding<Bool>) -> some View {
    ExpandableSelectionField(
      title: title,
      selection: time.wrappedValue.formattedTime(.hourMinuteBrief),
      showingContent: showing
    ) {
      TimeIntervalPicker(time)
    }
  }
}


struct TimerSetupView_Previews: PreviewProvider {
  static let store = Store<TimerSetupState, TimerSetupAction>(
    initialState: TimerSetupState(),
    reducer: .timerSetup,
    environment: .init()
  )

  static var previews: some View {
    NavigationView {
      TimerSetupView(store: store)
    }
  }
}
