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

extension Int: Scalar {}
extension Int8: Scalar {}
extension Int16: Scalar {}
extension Int32: Scalar {}
extension Int64: Scalar {}
extension Int128: Scalar {}
extension UInt: Scalar {}
extension UInt8: Scalar {}
extension UInt16: Scalar {}
extension UInt32: Scalar {}
extension UInt64: Scalar {}
extension UInt128: Scalar {}
extension Float: Scalar {}
extension Double: Scalar {}

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

extension Magnitude: Equatable {}

extension Magnitude: Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.value < rhs.value }
}

extension Magnitude: Hashable where Storage: Hashable {}
extension Magnitude: Sendable where Storage: Sendable {}

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

#if !hasFeature(Embedded)
    extension Magnitude: Codable where Storage: Codable {
        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(Storage.self)
            do {
                try self.init(validating: value)
            } catch {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Magnitude must be finite and nonnegative"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
#endif
