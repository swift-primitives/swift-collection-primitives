extension Collection {
    /// Protocol for collections that support backward traversal.
    ///
    /// `Collection.Bidirectional` extends `Collection.Protocol` with the ability
    /// to traverse elements in reverse order via `index(before:)`.
    ///
    /// ## Conforming to Collection.Bidirectional
    ///
    /// Implement `index(before:)` in addition to `Collection.Protocol` requirements:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Bidirectional {
    ///     func index(before i: Int) -> Int {
    ///         i - 1
    ///     }
    /// }
    /// ```
    ///
    /// ## Reverse Traversal
    ///
    /// Bidirectional collections enable operations that require backward movement:
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3, 4, 5])
    /// // Access last element efficiently
    /// let lastIndex = container.index(before: container.endIndex)
    /// let last = container[lastIndex]  // 5
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
