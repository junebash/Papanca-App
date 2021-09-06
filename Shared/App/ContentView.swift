import ComposableArchitecture
import SwiftUI

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    MainScreen(store)
  }
}

enum ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(store: Store(initialState: .init(), reducer: AppReducer(preferences: TempPreferencesClient())))
    }
}
