import SwiftUI


public enum ColorPalette: String, CaseIterable, Codable, Hashable {
  case day = "Day"
  case night = "Night"
}


// MARK: - Components

extension ColorPalette {
  public enum Category: String, CaseIterable, Hashable {
    case foreground, background
  }

  public enum Level: Int, CaseIterable, Hashable {
    case primary = 1, secondary, tertiary, quaternary
  }

  public var papancaBGGradient: Gradient {
    switch self {
    case .day: return .day
    case .night: return .night
    }
  }

  public func color(_ category: Category, _ level: Level) -> Color {
    Color("\(rawValue)/\(category.rawValue)-\(level.rawValue)")
  }

  public func callAsFunction(_ category: Category, _ level: Level) -> Color {
    color(category, level)
  }
}


// MARK: - Preference

extension ColorPalette {
  public enum Preference: Equatable, Codable {
    case system
    case constant(ColorPalette)
    case `switch`(day: ColorPalette, night: ColorPalette)

    public func colorPalette(for colorScheme: ColorScheme) -> ColorPalette {
      switch (self, colorScheme) {
      case (.system, .light):
        return .day
      case (.system, .dark):
        return .night
      case (.constant(let palette), _), (.switch(let palette, _), .light), (.switch(_, let palette), .dark):
        return palette
      @unknown default:
        assertionFailure("Unknown color palette preference or color schemes not being handled in \(#file),\(#function),\(#line)")
        return .day
      }
    }
  }
}


// MARK: - Previews

enum ColorPalette_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      ForEach(ColorPalette.allCases, id: \.self) { palette in
        Section(palette.rawValue) {
          VStack(spacing: 0) {
            ForEach(ColorPalette.Category.allCases, id: \.self) { category in
              ForEach(ColorPalette.Level.allCases, id: \.self) { level in
                palette(category, level)
              }
            }
          }.border(Color.black)
        }
      }
    }
  }
}
