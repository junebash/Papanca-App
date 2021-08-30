import SwiftUI


private enum DefaultGeometryKey<Tag, Value>: PreferenceKey {
  public static var defaultValue: Value? { nil }

  public static func reduce(value: inout Value?, nextValue: () -> Value?) {
    value = nextValue() ?? value
  }
}


public struct ReadGeometry<Key: PreferenceKey>: ViewModifier
where Key.Value: Equatable {
  typealias Value = Key.Value

  @Binding var value: Value
  let getValue: (GeometryProxy) -> Value

  public func body(content: Content) -> some View {
    content.background {
      GeometryReader { proxy in
        Color.clear
          .preference(key: Key.self, value: getValue(proxy))
      }
    }.onPreferenceChange(Key.self) { value = $0 }
  }
}


extension View {
  public func readingGeometry<Key: PreferenceKey>(
    key _: Key.Type,
    to binding: Binding<Key.Value>,
    _ getValue: @escaping (GeometryProxy) -> Key.Value
  ) -> some View
  where Key.Value: Equatable {
    self.modifier(ReadGeometry<Key>(value: binding, getValue: getValue))
  }

  public func readingLatestGeometry<Value: Equatable>(
    to binding: Binding<Value?>,
    _ getValue: @escaping (GeometryProxy) -> Value
  ) -> some View {
    self.modifier(ReadGeometry<DefaultGeometryKey<Self, Value>>(value: binding, getValue: getValue))
  }

  public func readingGeometry<Value: Equatable, Tag>(
    tag _: Tag.Type,
    to binding: Binding<Value?>,
    _ getValue: @escaping (GeometryProxy) -> Value
  ) -> some View {
    self.modifier(ReadGeometry<DefaultGeometryKey<Tag, Value>>(value: binding, getValue: getValue))
  }
}
