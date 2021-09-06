extension Result {
  init(_ tryMake: () async throws -> Success) async where Failure == Error {
    do {
      self = try await .success(tryMake())
    } catch {
      self = .failure(error)
    }
  }
}
