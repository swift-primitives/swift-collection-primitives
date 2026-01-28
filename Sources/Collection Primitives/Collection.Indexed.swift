public import Comparison_Primitives

extension Collection {
    /// Protocol for index-based navigation, supporting `~Copyable` types.
    ///
    /// `Collection.Indexed` provides index navigation without requiring
    /// `makeIterator()`. This enables index-based iteration over containers
    /// with `~Copyable` elements.
    ///
    /// ## Design Note: Element Access
    ///
    /// This protocol intentionally does **not** include `associatedtype Element`
    /// or `subscript(position:) -> Element`. Swift does not currently support
    /// `associatedtype Element: ~Copyable` (deferred from SE-0427), so protocols
    /// with `associatedtype Element` implicitly require `Element: Copyable`.
    ///
    /// **Conformers provide subscript as a direct member**, not a protocol
    /// requirement. This enables full `~Copyable` element support while
    /// maintaining protocol-based index navigation.
    ///
    /// See: SE-0427 "Noncopyable Generics" Future Directions.
    ///
    /// ## Difference from Collection.Protocol
    ///
    /// | Aspect | `Collection.Protocol` | `Collection.Indexed` |
    /// |--------|----------------------|---------------------|
    /// | Inherits from | `Sequence.Protocol` | Nothing |
    /// | Requires `makeIterator()` | Yes | No |
    /// | Element in protocol | Yes (implicit Copyable) | No (conformer provides) |
    /// | Index constraint | `Comparable` | `Comparison.Protocol` |
    /// | Use case | Copyable elements | Any elements |
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
    /// ## ForEach Integration
    ///
    /// Types conforming to `Collection.Indexed` can add a `.forEach` property
    /// to get borrowing iteration via `Property.View` extensions:
    ///
    /// ```swift
    /// extension TokenContainer: Property.ForEach {
    ///     var forEach: Property.View<Self, Collection.ForEach> {
    ///         Property.view(of: &self, as: Swift.Collection.ForEach.self)
    ///     }
    /// }
    ///
    /// var container = TokenContainer(...)
    /// container.forEach { token in
    ///     print(token.id)  // borrowing access, not consuming
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
}
