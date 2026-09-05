import Foundation
import Magnitude
import Tagged
import Testing

private enum InnerDomain {}
private enum OuterDomain {}

private func requireExactType<T>(_ value: T, _: T.Type) {}

@Test
func `integer validation accepts zero and positive boundaries`() throws {
    #expect(try Magnitude<Int>(validating: 0) == .zero)
    #expect(try Magnitude<Int>(validating: Int.max).value == Int.max)
    #expect(try Magnitude<UInt>(validating: UInt.max).value == UInt.max)
}

@Test
func `integer validation rejects negative values`() {
    #expect(throws: Magnitude<Int>.Error.negative) {
        try Magnitude<Int>(validating: -1)
    }
}

@Test
func `floating point validation rejects nonfinite and negative values`() {
    #expect(throws: Magnitude<Double>.Error.nonfinite) {
        try Magnitude<Double>(validating: .nan)
    }
    #expect(throws: Magnitude<Double>.Error.nonfinite) {
        try Magnitude<Double>(validating: .infinity)
    }
    #expect(throws: Magnitude<Double>.Error.nonfinite) {
        try Magnitude<Double>(validating: -.infinity)
    }
    #expect(throws: Magnitude<Double>.Error.negative) {
        try Magnitude<Double>(validating: -0.5)
    }
}

@Test
func `negative floating point zero canonicalizes to positive zero`() throws {
    let value = try Magnitude<Double>(validating: -0.0)
    #expect(value == .zero)
    #expect(value.value.sign == .plus)
}

@Test
func `Codable round trip validates decoded values`() throws {
    let source = try Magnitude<Double>(validating: 3.5)
    let encoded = try JSONEncoder().encode(source)
    let decoded = try JSONDecoder().decode(Magnitude<Double>.self, from: encoded)
    #expect(decoded == source)
    #expect(throws: DecodingError.self) {
        try JSONDecoder().decode(Magnitude<Double>.self, from: Data("-1".utf8))
    }
    let data = try PropertyListEncoder().encode([Double.infinity])
    #expect(throws: DecodingError.self) {
        try PropertyListDecoder().decode([Magnitude<Double>].self, from: data)
    }
}

@Test
func `tagged projection retains its domain and value role`() throws {
    let value = try Magnitude<Int>(validating: 7)
    let source = Tagged<InnerDomain, Magnitude<Int>>(_unchecked: value)
    let projected = source.magnitude
    requireExactType(projected, Tagged<InnerDomain, Magnitude<Int>>.self)
    #expect(projected == Tagged<InnerDomain, Magnitude<Int>>(_unchecked: value))
}

@Test
func `nested tagged projection retains every domain layer`() throws {
    let value = try Magnitude<Int>(validating: 11)
    let inner = Tagged<InnerDomain, Magnitude<Int>>(_unchecked: value)
    let source = Tagged<OuterDomain, Tagged<InnerDomain, Magnitude<Int>>>(
        _unchecked: inner
    )
    let projected = source.magnitude
    requireExactType(
        projected,
        Tagged<OuterDomain, Tagged<InnerDomain, Magnitude<Int>>>.self
    )
    #expect(
        projected
            == Tagged<OuterDomain, Tagged<InnerDomain, Magnitude<Int>>>(
                _unchecked: inner
            )
    )
}
