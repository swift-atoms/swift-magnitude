import Tagged

#if !hasFeature(Embedded)
extension Magnitude: Swift.Codable where Storage: Swift.Codable {
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
