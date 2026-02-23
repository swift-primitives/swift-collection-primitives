public import Comparison_Primitives

extension Collection {
    /// Protocol for index-based navigation, supporting `~Copyable` types.
    ///
    /// > Legacy note: With `Collection.Protocol` now standalone (no `Sequence.Protocol`
    /// > inheritance), `Collection.Protocol` itself provides index-based access
    /// > without `makeIterator()`. However, `Collection.Indexed` cannot be folded
    /// > into `Collection.Protocol` because Protocol's `subscript -> Element { get }`
    /// > triggers implicit `Element: Copyable` through protocol inheritance chains.
    /// > `Collection.Indexed` remains as the ~Copyable-safe root for the
    /// > `Bidirectional` → `Access.Random` hierarchy.
    ///
    /// `Collection.Indexed` provides index navigation without requiring
    /// `makeIterator()`. This enables index-based iteration over containers
    /// with `~Copyable` elements.
    ///
    /// ## Design Note: Element Access
    ///
    /// This protocol intentionally does **not** include `associatedtype Element`
    /// or `subscript(position:) -> Element`. Including `subscript -> Element { get }`
    /// in a protocol triggers implicit `Element: Copyable` when conformers use
    /// `where Element: ~Copyable` constraints. By omitting element access,
    /// `Collection.Indexed` remains safe for the ~Copyable hierarchy.
    ///
    /// **Conformers provide subscript as a direct member**, not a protocol
    /// requirement. This enables full `~Copyable` element support while
    /// maintaining protocol-based index navigation.
    ///
    /// ## Relationship to Collection.Protocol
    ///
    /// | Aspect | `Collection.Protocol` | `Collection.Indexed` |
    /// |--------|----------------------|---------------------|
    /// | Has `Element` | Yes (`~Copyable`) | No |
    /// | Has `subscript` | Yes | No |
    /// | Supports ~Copyable inheritance | Blocked by `{ get }` | Yes |
    /// | Use case | Standalone collection API | Bidirectional hierarchy root |
    ///
    /// ## Conforming to Collection.Indexed
    ///
    /// Implement the required index navigation members using typed indices,
    /// then add subscript as a direct member:
    ///
    /// ```swift
    /// struct TokenContainer: ~Copyable {
    ///     var storage: UnsafeMutableBufferPointer<Token>
    ///     var _count: Int
    /// }
    ///
    /// extension TokenContainer: Collection.Indexed {
    ///     typealias Index = Index_Primitives.Index<Token>
    ///
    ///     var startIndex: Index { .zero }
    ///     var endIndex: Index { Index(__unchecked: (), position: _count) }
    ///     func index(after i: Index) -> Index { (i + Index.Offset(1))! }
    ///
    ///     // Element access as direct member (not protocol requirement)
    ///     subscript(position: Index) -> Token {
    ///         _read { yield storage[position.position] }
    ///     }
    /// }
    /// ```
    ///
    /// ## Semantic Requirements
    ///
    /// - `startIndex <= endIndex`
    /// - `startIndex == endIndex` implies empty collection
    /// - `index(after: i)` must return `endIndex` when `i` is the last valid index
    public protocol Indexed: ~Copyable {
        /// A type that represents a position in the collection.
        ///
        /// Uses `Comparison.Protocol` instead of stdlib `Comparable` to support
        /// `~Copyable` index types.
        associatedtype Index: Comparison.`Protocol`

        /// The position of the first element in a non-empty collection.
        ///
        /// For an empty collection, `startIndex == endIndex`.
        var startIndex: Index { get }

        /// The collection's "past the end" position.
        ///
        /// `endIndex` is not a valid subscript argument. It represents the
        /// position one past the last valid index.
        var endIndex: Index { get }

        /// Returns the position immediately after the given index.
        ///
        /// - Parameter i: A valid index of the collection. `i` must be less than `endIndex`.
        /// - Returns: The index immediately after `i`.
        func index(after i: Index) -> Index
    }
}

// MARK: - Protocol Extensions

extension Collection.Indexed where Self: ~Copyable {
    /// A Boolean value indicating whether the collection is empty.
    @inlinable
    public var isEmpty: Bool { startIndex == endIndex }

    /// Updates the given index to its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than `endIndex`.
    @inlinable
    public func formIndex(after i: inout Index) {
        i = index(after: i)
    }
}
