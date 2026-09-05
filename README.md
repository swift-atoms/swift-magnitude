# swift-magnitude

`Magnitude<Scalar>` stores a validated finite, nonnegative scalar. Construction
rejects negative and nonfinite values and canonicalizes floating-point negative
zero.

`Representable` describes values that expose an associated magnitude.
When such a value is wrapped in `Tagged`, its magnitude projection retains the
outer tag, including through nested tags.

`Scalar` supplies the scalar domain's zero and finiteness semantics.
The package provides conformances for Swift's standard integer, `Float`, and
`Double` types without prescribing a new numeric representation.
