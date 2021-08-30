import ComposableArchitecture
import SwiftUI


public protocol BindableAction {
  associatedtype State

  static func binding(_ bindingAction: BindingAction<State>) -> Self
}


extension Reducer where Action: BindableAction, State == Action.State {
  public func binding() -> Self  {
    self.binding(action: /Action.binding)
  }
}


extension ViewStore where Action: BindableAction, Action.State == State {
  public func binding<V: Equatable>(to keyPath: WritableKeyPath<State, V>) -> Binding<V> {
    self.binding(keyPath: keyPath, send: Action.binding)
  }
}
