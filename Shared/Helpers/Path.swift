import CasePaths
import SwiftUI


public protocol WritablePath {
  associatedtype Root
  associatedtype Value

  func embed(_ value: Value, in root: inout Root)
  func extract(from root: Root) -> Value?
}

extension WritablePath {
  func embedded(_ value: Value, in root: Root) -> Root {
    var root = root
    embed(value, in: &root)
    return root
  }
}


public struct AnyWritablePath<Root, Value>: WritablePath {
  private let _embed: (Value, inout Root) -> Void
  private let _extract: (Root) -> Value?

  public init(embed: @escaping (Value, inout Root) -> Void, extract: @escaping (Root) -> Value?) {
    self._embed = embed
    self._extract = extract
  }

  public init<P: WritablePath>(_ path: P)
  where P.Root == Root, P.Value == Value {
    self.init(embed: path.embed(_:in:), extract: path.extract(from:))
  }

  public func extract(from root: Root) -> Value? {
    _extract(root)
  }

  public func embed(_ value: Value, in root: inout Root) {
    _embed(value, &root)
  }
}


extension WritableKeyPath: WritablePath {
  public func extract(from root: Root) -> Value? {
    root[keyPath: self]
  }

  public func embed(_ value: Value, in root: inout Root) {
    root[keyPath: self] = value
  }
}


extension CasePath: WritablePath {
  public func embed(_ value: Value, in root: inout Root) {
    root = embed(value)
  }
}


public struct AppendingPath<RootPath: WritablePath, AppendedPath: WritablePath>: WritablePath
where RootPath.Value == AppendedPath.Root {
  public typealias Root = RootPath.Root
  public typealias Value = AppendedPath.Value

  let rootPath: RootPath
  let appendedPath: AppendedPath

  public func embed(_ value: AppendedPath.Value, in root: inout RootPath.Root) {
    guard var rootValue = rootPath.extract(from: root) else { return }
    appendedPath.embed(value, in: &rootValue)
    rootPath.embed(rootValue, in: &root)
  }

  public func extract(from root: RootPath.Root) -> AppendedPath.Value? {
    rootPath.extract(from: root).flatMap(appendedPath.extract(from:))
  }
}

extension WritablePath {
  public func appending<P: WritablePath>(_ path: P) -> AppendingPath<Self, P>
  where Value == P.Root {
    AppendingPath(rootPath: self, appendedPath: path)
  }
}


public func .. <L: WritablePath, R: WritablePath>(l: L, r: R) -> AppendingPath<L, R>
where L.Value == R.Root {
  l.appending(r)
}


public struct ConstantPath<Value>: WritablePath {
  public init(_: Value.Type = Value.self) {}

  public func embed(_ value: Value, in root: inout Value) {
    root = value
  }

  public func extract(from root: Value) -> Value? {
    root
  }
}
