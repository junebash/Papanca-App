import SwiftUI

extension Gradient {
  public static var day: Gradient {
    Gradient(colors: [
      Color(red: 0.1, green: 0.5, blue: 0.7),
      Color(red: 0.4, green: 0.7, blue: 1),
      Color(red: 0.65, green: 0.8, blue: 0.75),
      Color(red: 0.9, green: 0.9, blue: 0.5),
      Color(red: 1, green: 0.95, blue: 0.75),
      Color(red: 1, green: 1, blue: 0.95),
      .white
    ])
  }

  public static var night: Gradient {
    Gradient(colors: [
      Color(red: 0.1, green: 0.1, blue: 0.4),
      Color(red: 0.17, green: 0.12, blue: 0.35),
      Color(red: 0.22, green: 0.06, blue: 0.25),
      Color(red: 0.12, green: 0.01, blue: 0.1),
      .black
    ])
  }

  public static var transitional: Gradient {
    Gradient(colors: [
      Color(red: 0.8, green: 0.7, blue: 0.1),
      Color(red: 0.82, green: 0.6, blue: 0.35),
      Color(red: 0.85, green: 0.5, blue: 0.6),
      Color(red: 0.6, green: 0.3, blue: 0.5),
      Color(red: 0.4, green: 0.2, blue: 0.3),
      Color(red: 0.15, green: 0.1, blue: 0.1)
    ])
  }
}


public struct PapancaBackground: View {
  private var gradient: Gradient

  public init(gradient: Gradient) {
    self.gradient = gradient
  }

  public var body: some View {
    LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: .top)
      .edgesIgnoringSafeArea(.all)
  }

  static func gradient(for hour: Int) -> Gradient {
    switch hour {
    case 5..<9, 17..<21: return .transitional
    case 9..<17: return .day
    default: return .night
    }
  }
}


enum PapancaBackground_Previews: PreviewProvider {
  static var previews: some View {
    PapancaBackground(gradient: .day)
    PapancaBackground(gradient: .transitional)
    PapancaBackground(gradient: .night)
      .colorScheme(.dark)
  }
}
