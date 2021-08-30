import ComposableArchitecture


extension ViewStore {
  func willSend(_ action: Action) -> () -> Void {
    { self.send(action) }
  }
}
