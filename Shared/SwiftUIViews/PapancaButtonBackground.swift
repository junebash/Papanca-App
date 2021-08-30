import SwiftUI


public struct PapancaButtonBackground: View {
  public var body: some View {
    let backgroundShape = RoundedRectangle(cornerRadius: 10)
    
    ZStack {
      Color(uiColor: .secondarySystemBackground)
        .clipShape(backgroundShape)
      backgroundShape
        .stroke(.tertiary)
    }
  }
}
