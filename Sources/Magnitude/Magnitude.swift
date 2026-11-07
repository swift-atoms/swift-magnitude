public import Tagged

public protocol Scalar: Comparable {
    static var zero: Self { get }
    var isFinite: Bool { get }
}

public protocol Representable {
    associatedtype Magnitude
    var magnitude: Magnitude { get }
}

extension Scalar where Self: BinaryInteger {
    @inlinable public var isFinite: Bool { true }
}

public struct Magnitude<Storage: Scalar> {
    private let storage: Storage

    public init(validating value: Storage) throws(Error) {
        guard value.isFinite else { throw .nonfinite }
        guard value >= .zero else { throw .negative }
        storage = value == .zero ? .zero : value
    }

    private init(validated value: Storage) {
        storage = value
    }
}

extension Magnitude {

    public var value: Storage { storage }

    public static var zero: Self { Self(validated: .zero) }
}

extension Magnitude: Swift::Equatable {}

extension Magnitude: Swift::Hashable where Storage: Swift::Hashable {}

extension Magnitude: Swift::Sendable where Storage: Swift::Sendable {}

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

extension Magnitude {

    public enum Error: Swift::Error, Hashable, Sendable {
        case negative
        case nonfinite
    }
}

#if !hasFeature(Embedded)
    extension Magnitude: Swift::Decodable where Storage: Swift::Decodable {
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
    }

    extension Magnitude: Swift::Encodable where Storage: Swift::Encodable {
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }
#endif

extension Magnitude: Swift::Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.value < rhs.value }
}
