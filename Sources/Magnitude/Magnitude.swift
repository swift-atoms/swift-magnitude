public import Tagged

/// A scalar that can be validated as a magnitude.
///
/// Conforming types must provide a lawful, stable `Comparable` order, a finite
/// `zero`, truthful finiteness, and value semantics that cannot invalidate a
/// `Magnitude` after construction.
public protocol Scalar: Comparable {
    static var zero: Self { get }
    var isFinite: Bool { get }
}

/// A value that exposes an associated magnitude representation.
public protocol Representable {
    associatedtype Magnitude
    var magnitude: Magnitude { get }
}

extension Scalar where Self: BinaryInteger {
    @inlinable public var isFinite: Bool { true }
}

/// A validated finite, nonnegative scalar value.
public struct Magnitude<Storage: Scalar> {
    private let storage: Storage

    public enum Error: Swift.Error, Hashable, Sendable {
        case negative
        case nonfinite
    }

    public init(validating value: Storage) throws(Error) {
        guard value.isFinite else { throw .nonfinite }
        guard value >= .zero else { throw .negative }
        storage = value == .zero ? .zero : value
    }

    private init(validated value: Storage) {
        storage = value
    }

    public var value: Storage { storage }

    public static var zero: Self { Self(validated: .zero) }
}

extension Magnitude: Swift.Equatable {}

extension Magnitude: Swift.Hashable where Storage: Swift.Hashable {}

extension Magnitude: Swift.Sendable where Storage: Swift.Sendable {}

extension Magnitude: Representable {
    public var magnitude: Self { self }
}

extension Tagged: Representable
where Underlying: Representable, Tag: ~Copyable & ~Escapable {
    public typealias Magnitude = Tagged<Tag, Underlying.Magnitude>

    @inlinable
    public var magnitude: Magnitude {
        Magnitude(_unchecked: underlying.magnitude)
    }
}
