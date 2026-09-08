# Magnitude

A finite, nonnegative scalar value. `Magnitude(validating:)` rejects negative and
nonfinite values and normalizes signed zero. The underlying `Scalar` protocol
provides comparison, zero, and finiteness; custom conformances must implement those
semantics consistently. `.zero` is the canonical zero magnitude.

```swift
import Magnitude
let length = try Magnitude(validating: 3.5)
let scalar = length.value
```

Storage is immutable. Decoding passes through the same validating constructor.
Encoding requires only Encodable storage; decoding requires only Decodable storage.
Comparison, hashing and sendability follow storage capabilities. Tagged projection
preserves domain tags without imposing arithmetic on tagged values.

Magnitude supplies value validity, not units or a metric. Size uses it for extents;
Ray and Ball use it for nonnegative parameters and radii respectively. Geometric
interpretation belongs to those domains and their explicit relationships.
