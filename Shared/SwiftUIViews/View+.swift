import SwiftUI

extension View {
  public func bigWide() -> some View {
    self
      .font(.headline)
      .padding(4)
      .frame(maxWidth: .infinity)
  }

  public func optionCaption() -> some View {
    self.font(.system(.subheadline, design: .rounded).lowercaseSmallCaps())
  }
}


