public struct UserPreferences: Equatable {
  public var colorPalette: ColorPalette.Preference = .system
}


public enum UserPreferencesError: Swift.Error, Equatable {
  case timeout // replace and add as needed
}


public protocol UserPreferencesClient {
  func loadUserPreferences() async -> Result<UserPreferences, UserPreferencesError>
  func saveUserPreferences(_ userPreferences: UserPreferences) async -> Result<Void, UserPreferencesError>
}


public struct TempPreferencesClient: UserPreferencesClient {
  public func loadUserPreferences() async -> Result<UserPreferences, UserPreferencesError> {
    .failure(.timeout)
  }

  public func saveUserPreferences(_ userPreferences: UserPreferences) async -> Result<Void, UserPreferencesError> {
    .failure(.timeout)
  }
}
