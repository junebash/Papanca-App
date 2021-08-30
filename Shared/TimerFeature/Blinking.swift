import SwiftUI


public struct Blinking<Content: View>: View {
  private let content: Content
  private let period: Double

  init(content: Content, animationDuration: Double, startsOpaque: Bool) {
    self.content = content
    self.period = animationDuration
    self._isOpaque = .init(initialValue: startsOpaque)
  }

  @State private var isOpaque: Bool

  private var animation: Animation {
    .easeInOut(duration: period)
    .repeatForever()
  }

  public var body: some View {
    content
      .opacity(isOpaque ? 1.0 : 0.0)
      .onAppear {
        withAnimation(animation) {
          isOpaque.toggle()
        }
      }
  }
}

extension View {
  func blinking(duration: Double = 1.0, startsOpaque: Bool = false) -> some View {
    Blinking(content: self, animationDuration: duration, startsOpaque: startsOpaque)
  }
}
