extension Collection {
    /// Namespace for access pattern types.
    public enum Access {}
}

extension Collection.Access {
    /// Protocol for collections with O(1) index distance and offset operations.
    ///
    /// `Collection.Access.Random` extends `Collection.Bidirectional` with a
    /// semantic guarantee that index arithmetic operations are O(1).
    ///
    /// ## Conforming to Collection.Access.Random
    ///
    /// No additional requirements beyond `Collection.Bidirectional`. Conformance
    /// is a declaration that index operations have O(1) complexity:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Access.Random {
    ///     // No additional implementation required.
    ///     // Conformance declares O(1) index arithmetic.
    /// }
    /// ```
    ///
    /// ## Performance Guarantee
    ///
    /// Conforming types guarantee O(1) complexity for:
    /// - `index(_:offsetBy:)`
    /// - `distance(from:to:)`
    /// - Subscript access
    ///
    /// ## Protocol Hierarchy
    ///
    /// ```
    /// Collection.Indexed              ← startIndex, endIndex, index(after:)
    ///       ↑
    /// Collection.Bidirectional        ← index(before:)
    ///       ↑
    /// Collection.Access.Random        ← O(1) guarantee
    ///
    /// Collection.Protocol             ← Element, subscript (separate hierarchy)
    /// ```
    public protocol Random: Collection.Bidirectional & ~Copyable {}
}
