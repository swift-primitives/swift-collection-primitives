public import Sequence_Primitives

extension Collection {
    /// Protocol for indexed, multi-pass sequences, supporting `~Copyable`.
    ///
    /// `Collection.Protocol` extends `Sequence.Protocol` with index-based
    /// element access. Unlike stdlib's `Collection`, this protocol supports
    /// `~Copyable` conformers.
    ///
    /// ## Conforming to Collection.Protocol
    ///
    /// Implement the required members:
    ///
    /// ```swift
    /// extension MyContainer: Collection.`Protocol` {
    ///     typealias Index = Int
    ///
    ///     var startIndex: Int { 0 }
    ///     var endIndex: Int { storage.count }
    ///
    ///     subscript(position: Int) -> Element {
    ///         storage[position]
    ///     }
    ///
    ///     func index(after i: Int) -> Int {
    ///         i + 1
    ///     }
    ///
    ///     func makeIterator() -> Array<Element>.Iterator {
    ///         storage.makeIterator()
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
    public protocol `Protocol`: Sequence_Primitives.Sequence.`Protocol` & ~Copyable {
        /// A type that represents a position in the collection.
        associatedtype Index: Comparable

        /// The position of the first element in a non-empty collection.
        var startIndex: Index { get }

        /// The collection's "past the end" position.
        var endIndex: Index { get }

        /// Accesses the element at the specified position.
        ///
        /// - Parameter position: The position of the element to access.
        /// - Returns: The element at the specified position.
        subscript(position: Index) -> Element { get }

        /// Returns the position immediately after the given index.
        ///
        /// - Parameter i: A valid index of the collection.
        /// - Returns: The index immediately after `i`.
        func index(after i: Index) -> Index
    }
}
