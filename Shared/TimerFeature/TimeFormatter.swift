import Foundation

public enum TimeFormat {
  case timer
  case hourMinuteBrief

  fileprivate func format(_ time: Double) -> String {
    switch self {
    case .timer:
      if time < 0.0 {
        return "-" + format(-time)
      }
      let totalSeconds = Int(time)
      let (hours, remainder) = totalSeconds.quotientAndRemainder(dividingBy: 3600)
      let (minutes, seconds) = remainder.quotientAndRemainder(dividingBy: 60)

      return [String(hours), paddedPlace(for: minutes), paddedPlace(for: seconds)]
        .joined(separator: ":")
    case .hourMinuteBrief:
      return time == 0 ? "" : DateComponentsFormatter.hourMinuteBrief.string(from: time) ?? ""
    }
  }

  private func paddedPlace(for place: Int) -> String {
    switch place {
    case ..<0: return ""
    case 0...9: return "0\(place)"
    default: return String(place)
    }
  }
}

extension Double {
  public func formattedTime(_ format: TimeFormat = .timer) -> String {
    format.format(self)
  }
}


public extension DateComponentsFormatter {
  static let hourMinuteBrief: DateComponentsFormatter = configure(DateComponentsFormatter()) {
    $0.allowedUnits = [.hour, .minute]
    $0.unitsStyle = .brief
    $0.collapsesLargestUnit = true
  }
}
