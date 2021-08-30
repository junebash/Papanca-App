import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    var body: some View {
//      TimerFeatureView(store: Store(
//        initialState: TimerState(
//          mode: .countUp,
//          actualStart: .now,
//          time: TimerState.Time(start: .now, current: .now),
//          isPaused: false
//        ),
//        reducer: timerReducer,
//        environment: TimerEnvironment(
//          mainRunLoop: .main,
//          now: { .now }
//        )
//      ))

//      TimerSetupView(store: Store(
//        initialState: .init(),
//        reducer: Reducer.empty.binding(),
//        environment: ()
//      ))
      MainScreen(Store<AppState, AppAction>(
        initialState: .init(hourOfDay: 0),
        reducer: .empty()
      ))
    }
}

enum ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
