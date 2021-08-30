import SwiftUI


public struct TimerView: View {
  public init(
    timeRemaining: TimeInterval,
    isPaused: Binding<Bool>,
    finish: @escaping () -> Void
  ) {
    self.timeRemaining = timeRemaining
    self._isPaused = isPaused
    self.finish = finish
  }

  // MARK: - State

  var timeRemaining: TimeInterval
  @Binding var isPaused: Bool
  let finish: () -> Void

  var isFinished: Bool {
    timeRemaining <= 0.0
  }

  var pauseButtonText: LocalizedStringKey {
    isPaused ? "Resume" : "Pause"
  }

  var finishButtonText: LocalizedStringKey {
    isFinished ? "Finish" : "Finish Early"
  }

  // MARK: - View

  public var body: some View {
    VStack {
      PauseIcon()
        .blinking(startsOpaque: false)
        .opacity(isPaused ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.2), value: isPaused)

      TimeAmountView(timeRemaining: timeRemaining)

      Button(action: { isPaused.toggle() }) {
        Text(pauseButtonText)
          .bigWide()
      }
      .buttonStyle(.bordered)
      .padding(4)

      Button(action: finish) {
        Text(finishButtonText)
          .bigWide()
      }
      .buttonStyle(.borderedProminent)
      .padding(4)
    }
    .frame(width: 300)
  }
}


private struct PauseIcon: View {
  var body: some View {
    Image(systemName: "pause.circle")
      .resizable()
      .aspectRatio(contentMode: .fit)
      .foregroundColor(.gray)
      .frame(maxHeight: 100)
      .font(.largeTitle.weight(.thin))
  }
}


// MARK: - Previews

enum TimerView_Previews: PreviewProvider {
  private struct Container: View {
    let timeRemaining: Double
    @State var isPaused: Bool

    var body: some View {
      TimerView(timeRemaining: timeRemaining, isPaused: $isPaused, finish: {})
    }
  }

  static var previews: some View {
    Container(timeRemaining: 321, isPaused: false)
      .previewLayout(.sizeThatFits)
      .padding()

    Container(timeRemaining: 321, isPaused: true)
      .previewLayout(.sizeThatFits)
      .padding()
  }
}


