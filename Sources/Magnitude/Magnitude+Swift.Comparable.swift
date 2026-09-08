import Tagged

extension Magnitude: Swift.Comparable {
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.value < rhs.value }
}
