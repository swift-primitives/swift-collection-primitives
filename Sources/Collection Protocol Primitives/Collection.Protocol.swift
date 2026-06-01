public import Comparison_Primitives
public import Index_Primitives
public import Iterable

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
    ///     var endIndex: Index { Index(_unchecked: position: storage.count) }
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
    /// ## Relationship to Iterable / Sequenceable
    ///
    /// `Collection.Protocol` refines `Iterable` (the multipass / borrow attachable):
    /// a collection IS-A multipass iterable, so every conformer vends a canonical
    /// `makeIterator()` and inherits the `Iterable` terminals (`forEach`, `reduce`,
    /// `contains`, `first`, …). The refinement carries **no** `makeIterator()`
    /// default: there is deliberately no index-walk `makeIterator()` on
    /// `Collection.Protocol`. Each conformer supplies its own `Iterable` witness —
    /// a span-based bulk iterator (`__IteratorChunkProtocol`) over its storage — so
    /// iteration borrows elements through the span addressor and carries both
    /// `Copyable` and `~Copyable` element kinds. An index-walk default would force a
    /// scalar move-out and reintroduce a `Copyable` gate, so it is intentionally
    /// absent.
    ///
    /// It does **not** refine `Sequenceable` (single-pass / consume): collections are
    /// multipass by construction. (The prior `Sequence.Protocol` was renamed to the
    /// top-level `Sequenceable` by the sequencer-refactor and no longer exists.)
    public protocol `Protocol`: Iterable, ~Copyable {
        associatedtype Element: ~Copyable

        // `Index` is a `~Escapable`-admitting associatedtype (default `Index<Element>`)
        // so conformers with custom index domains (e.g. storage-slot positions) can
        // supply their own. Verified viable via Experiments/collection-index-escapable-lifetime.
        associatedtype Index: Comparison.`Protocol` & ~Escapable = Index_Primitives.Index<Element>
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
        ///
        /// The successor's lifetime derives from the input index `i` (not from a
        /// borrow of `self`), so a `~Escapable` index survives the storable-index
        /// contract (`formIndex(after: inout Index)`). See the experiment above.
        @_lifetime(copy i)
        func index(after i: Index) -> Index
    }
}
