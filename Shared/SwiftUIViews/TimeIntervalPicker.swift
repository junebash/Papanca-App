import SwiftUI

public struct TimeIntervalPicker: View {
  public enum MinuteInterval: Int {
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6
    case ten = 10
    case twelve = 12
    case fifteen = 15
    case twenty = 20
    case thirty = 30
  }

  @Binding var timeInterval: TimeInterval
  let minuteInterval: MinuteInterval

  public init(_ timeInterval: Binding<TimeInterval>, minuteInterval: MinuteInterval = .one) {
    self._timeInterval = timeInterval
    self.minuteInterval = minuteInterval
  }

  public var body: some View {
    _TimeIntervalPickerRepresentable(timeInterval: $timeInterval, minuteInterval: minuteInterval)
  }
}

private struct _TimeIntervalPickerRepresentable: UIViewRepresentable {
  @Binding var timeInterval: TimeInterval
  let minuteInterval: TimeIntervalPicker.MinuteInterval

  func makeUIView(context: Context) -> UIDatePicker {
    let picker = UIDatePicker(frame: .zero, primaryAction: UIAction(handler: { action in
      guard let picker = action.sender as? UIDatePicker else { return }
      timeInterval = picker.countDownDuration
    }))

    picker.datePickerMode = .countDownTimer
    picker.minuteInterval = minuteInterval.rawValue
    picker.countDownDuration = timeInterval
    return picker
  }

  func updateUIView(_ uiView: UIDatePicker, context: Context) {
    uiView.countDownDuration = timeInterval
    uiView.minuteInterval = minuteInterval.rawValue
  }
}
