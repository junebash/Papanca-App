import SwiftUI
import ComposableArchitecture


public struct QuickTimerState: Equatable {
  public var time: Double = 600.0
}


public enum QuickTimerAction: Equatable {
  case setTime(Double)
  case startTimer
  case show
  case dismiss
}


struct QuickTimerSetupView: View {
  let store: Store<QuickTimerState, QuickTimerAction>

  var body: some View {
    WithViewStore(store) { viewStore in
      VStack {
        TimeIntervalPicker(viewStore.binding(get: \.time, send: QuickTimerAction.setTime))
        HStack {
          Button(action: viewStore.willSend(.dismiss)) {
            Text("Cancel")
          }
          .buttonStyle(.bordered)

          Button(action: viewStore.willSend(.startTimer)) {
            Text("Start!")
          }
          .buttonStyle(.borderedProminent)
        }
      }
    }
  }
}
