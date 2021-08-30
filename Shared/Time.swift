import Foundation

public struct Time: Hashable {
  public var hours: Int
  public var minutes: Int
  public var seconds: Int
  public var remainder: TimeInterval

  public var timeInterval: TimeInterval {
    TimeInterval(hours * 3600 + minutes * 60 + seconds) + remainder
  }

  public mutating func add(_ timeInterval: TimeInterval) {
    self = .init(timeInterval: timeInterval + self.timeInterval)
  }

  public var hmsString: String {
    func formatMinSec(_ int: Int) -> String {
      switch int {
      case ..<0: return formatMinSec(-int)
      case 0...9: return "0\(int)"
      default: return String(int)
      }
    }

    return "\(hours):\(formatMinSec(minutes)):\(formatMinSec(seconds))"
  }

  public init(hours: Int, minutes: Int, seconds: Int, remainder: TimeInterval) {
    self.hours = hours
    self.minutes = minutes
    self.seconds = seconds
    self.remainder = remainder
  }

  public init(timeInterval: TimeInterval) {
    let (totalMinutes, seconds) = Int(timeInterval).quotientAndRemainder(dividingBy: 60)
    let (hours, minutes) = totalMinutes.quotientAndRemainder(dividingBy: 60)

    self.init(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      remainder: timeInterval - TimeInterval(seconds)
    )
  }
}
