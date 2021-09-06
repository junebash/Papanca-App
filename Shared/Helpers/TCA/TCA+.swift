import ComposableArchitecture
import Combine


extension ViewStore {
  func willSend(_ action: Action) -> () -> Void {
    { self.send(action) }
  }
}


extension ViewStore where State == Bool, Action == Bool {
  func toggle() {
    send(!state)
  }
}


extension Effect {
  static func asyncFuture(_ work: @escaping (@escaping (Result<Output, Failure>) -> Void) async -> Void) -> Effect {
    Deferred {
      Future { completion in
        Task {
          await work(completion)
        }
      }
    }
    .eraseToEffect()
  }

  static func task(_ task: Task<Output, Failure>) -> Effect {
    Deferred {
      Future { completion in
        Task { await completion(task.result) }
      }
    }
    .handleEvents(receiveCancel: { task.cancel() })
    .eraseToEffect()
  }

  static func `async`(_ work: @escaping () async -> Output) -> Effect {
    Deferred {
      Future { completion in
        Task { completion(.success(await work())) }
      }
    }
    .eraseToEffect()
  }

  static func asyncResult(_ work: @escaping () async -> Result<Output, Failure>) -> Effect {
    Deferred {
      Future { completion in
        Task { completion(await work()) }
      }
    }
    .eraseToEffect()
  }

  static func asyncThrowing(_ work: @escaping () async throws -> Output) -> Effect
  where Failure == Error {
    Deferred { () -> Publishers.HandleEvents<Future<Output, Error>> in
      let task = Task { try await work() }
      return Future { completion in
        Task { () -> Void in
          guard !task.isCancelled else {
            return completion(.failure(CancellationError()))
          }
          await completion(task.result)
        }
      }
      .handleEvents(receiveCancel: { task.cancel() })
    }
    .eraseToEffect()
  }
}
