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
