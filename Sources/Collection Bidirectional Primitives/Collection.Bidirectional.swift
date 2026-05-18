extension Collection {
    /// Protocol for collections that support backward index traversal.
    ///
    /// `Collection.Bidirectional` extends `Collection.Protocol` with the ability
    /// to traverse indices in reverse order via `index(before:)`. The
    /// `~Copyable` element support flows from `Collection.Protocol`'s
    /// `associatedtype Element: ~Copyable`.
    ///
    /// ## Conforming to Collection.Bidirectional
    ///
    /// Implement `index(before:)` in addition to `Collection.Protocol` requirements
    /// using typed indices:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Bidirectional {
    ///     typealias Index = Index_Primitives.Index<Element>
    ///
    ///     // From Collection.Protocol:
    ///     var startIndex: Index { .zero }
    ///     var endIndex: Index { Index(_unchecked: position: count) }
    ///     func index(after i: Index) -> Index { (i + Index.Offset(1))! }
    ///
    ///     // From Collection.Bidirectional:
    ///     func index(before i: Index) -> Index { (i - Index.Offset(1))! }
    /// }
    /// ```
    ///
    /// ## Reverse Traversal
    ///
    /// Bidirectional collections enable operations that require backward movement:
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3, 4, 5])
    /// // Access last index efficiently
    /// let lastIndex = container.index(before: container.endIndex)
    /// ```
    public protocol Bidirectional: Collection.`Protocol` & ~Copyable {
        /// Returns the position immediately before the given index.
        ///
        /// - Parameter i: A valid index of the collection. `i` must be greater
        ///   than `startIndex`.
        /// - Returns: The index immediately before `i`.
        func index(before i: Index) -> Index
    }
}
