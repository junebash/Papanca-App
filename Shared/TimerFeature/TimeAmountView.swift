import SwiftUI


public struct TimeAmountView: View {
  public let timeRemaining: Double

  public init(timeRemaining: Double) {
    self.timeRemaining = timeRemaining
  }

  private var nonNegativeTimeRemaining: Double {
    timeRemaining >= 0.0 ? timeRemaining : 0.0
  }

  public var body: some View {
    VStack {
      Text(nonNegativeTimeRemaining.formattedTime())
        .font(.system(size: 60.0, design: .rounded).monospacedDigit())
        .padding()

      Group {
        Text("Additional Time:")
          .font(.caption.lowercaseSmallCaps())

        Text((-timeRemaining).formattedTime())
          .font(.body.monospacedDigit())
      }
      .foregroundColor(timeRemaining < 0 ? nil : .clear)
    }
  }
}


enum CountdownView_Previews: PreviewProvider {
  static var times: [Double] = [321.0, 0.0, -10.0]

  static var previews: some View {
    ForEach(times, id: \.self) { time in
      TimeAmountView(timeRemaining: time)
        .previewLayout(.sizeThatFits)
        .padding()
    }
  }
}
