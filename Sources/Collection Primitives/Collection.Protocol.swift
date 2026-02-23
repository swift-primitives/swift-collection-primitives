public import Index_Primitives

extension Collection {
    /// Protocol for indexed, multi-pass collections, supporting `~Copyable`.
    ///
    /// `Collection.Protocol` provides index-based element access for multi-pass
    /// iteration. Unlike stdlib's `Collection`, this protocol supports
    /// `~Copyable` conformers and `~Copyable` elements.
    ///
    /// ## Conforming to Collection.Protocol
    ///
    /// Implement the required members using typed indices:
    ///
    /// ```swift
    /// extension MyContainer: Collection.`Protocol` {
    ///     var startIndex: Index { .zero }
    ///     var endIndex: Index { Index(__unchecked: (), position: storage.count) }
    ///
    ///     subscript(_ position: Index) -> Element {
    ///         storage[position.position]
    ///     }
    ///
    ///     func index(after i: Index) -> Index {
    ///         (i + Index.Offset(1))!
    ///     }
    /// }
    /// ```
    ///
    /// ## Multi-Pass Guarantee
    ///
    /// Unlike single-pass sequences, collections can be iterated multiple times:
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach { print($0) }  // 1, 2, 3
    /// container.forEach { print($0) }  // 1, 2, 3 (again)
    /// ```
    ///
    /// ## Relationship to Sequence.Protocol
    ///
    /// `Collection.Protocol` does not inherit from `Sequence.Protocol`.
    /// Collections iterate via index traversal (`startIndex`, `index(after:)`),
    /// not via `makeIterator()` / `next()`. Types wanting `Swift.Collection`
    /// or `for-in` syntax should also conform to `Sequence.Protocol` separately.
    public protocol `Protocol`: ~Copyable {
        associatedtype Element: ~Copyable

        typealias Index = Index_Primitives.Index<Element>
        /// The position of the first element in a non-empty collection.
        var startIndex: Index { get }

        /// The collection's "past the end" position.
        var endIndex: Index { get }

        /// Accesses the element at the specified position.
        ///
        /// - Parameter position: The position of the element to access.
        /// - Returns: The element at the specified position.
        subscript(_ position: Index) -> Element { get }

        /// Returns the position immediately after the given index.
        ///
        /// - Parameter i: A valid index of the collection.
        /// - Returns: The index immediately after `i`.
        func index(after i: Index) -> Index
    }
}
