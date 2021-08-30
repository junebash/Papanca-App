import SwiftUI


public struct AnyViewModifier<Output: View>: ViewModifier {
  private let modifier: (Content) -> Output

  public init(@ViewBuilder _ modifier: @escaping (AnyViewModifier<Output>.Content) -> Output) {
    self.modifier = modifier
  }

  public func body(content: Content) -> some View {
    modifier(content)
  }
}

extension ViewModifier {
  public static func anyModifier<Output: View>(@ViewBuilder _ modifier: @escaping (Content) -> Output) -> AnyViewModifier<Output>
  where Self == AnyViewModifier<Output> {
    .init(modifier)
  }
}
