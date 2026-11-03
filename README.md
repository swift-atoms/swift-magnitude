# swift-magnitude

Use this package when a value must be a finite, nonnegative amount of some scalar, such as a length, a duration or a count, and you want that checked once at the boundary instead of at every use. Start from `Magnitude<Storage>`, which validates on construction; conform your own scalar type through the module's `Scalar` protocol, and give a domain type a `magnitude` through `Representable`. This package carries no arithmetic; for nonnegative counts that add and subtract, use swift-cardinal, which builds its arithmetic on `Magnitude<Storage>`.

## Laws

- Finiteness is checked before sign: negative infinity is rejected as nonfinite, not as negative.
- Zero is canonical: any value equal to `Storage.zero`, including floating-point `-0.0`, is stored as `Storage.zero`, so a stored zero is always positive zero.
- A `BinaryInteger` scalar is finite unless it overrides `isFinite`, so only the sign is checked for integers.
- Equality, hashing and ordering are those of the stored value.
- Encoding writes the bare stored value, with no wrapper. Decoding reads that value and validates it again; a negative or nonfinite value fails decoding as data corruption. Encoding requires only an `Encodable` scalar and decoding only a `Decodable` one. Codable conformance is absent under Embedded Swift.
- `Magnitude<Storage>.magnitude` is the value itself. The `magnitude` of a `Tagged` value keeps every tag layer and projects only the innermost value, so its type is the source's type when that value is already a `Magnitude<Storage>`.
