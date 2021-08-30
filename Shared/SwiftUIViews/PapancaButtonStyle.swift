import SwiftUI


public struct PapancaButtonStyle: ButtonStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.horizontal, 6)
      .padding(.vertical, 5)
      .background(PapancaButtonBackground())
      .opacity(configuration.isPressed ? 0.6 : 1.0)
      .compositingGroup()
      .shadow(radius: 5)
  }
}

extension ButtonStyle where Self == PapancaButtonStyle {
  static var papanca: Self {
    PapancaButtonStyle()
  }
}


enum PapancaButtonStyle_Previews: PreviewProvider {
  static var previews: some View {
    Button("Hello") { print("hello") }
      .buttonStyle(.papanca)
      .padding()
      .previewLayout(.sizeThatFits)

    Button("Hello") { print("hello") }
      .buttonStyle(.papanca)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}

