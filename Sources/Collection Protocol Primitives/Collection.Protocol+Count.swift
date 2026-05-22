public import Index_Primitives

extension Collection.`Protocol` where Self: ~Copyable {
    /// The number of elements in the collection.
    ///
    /// Default iterates from `startIndex` to `endIndex` counting via
    /// `index(after:)`. O(n) for the protocol-default implementation;
    /// O(1) when overridden on types with stored counts (the common
    /// case for stable-storage Group A conformers — Buffer, Array,
    /// Queue, Set.Ordered, Dictionary.Ordered, Heap, Vector, etc.).
    ///
    /// Borrowing accessor — does not consume the receiver. Mirrors
    /// Apple stdlib's `Collection.count: Int` placement; relocated
    /// from `Sequence.\`Protocol\`` per
    /// `swift-institute/Research/2026-05-22-sequence-protocol-count-relocation-impact.md`
    /// (RECOMMENDATION Option a, 2026-05-22). For filter-count, see
    /// `Sequence.\`Protocol\`.count(where:)`.
    @inlinable
    public var count: Index_Primitives.Index<Element>.Count {
        borrowing get {
            var i = startIndex
            let end = endIndex
            var n = Cardinal.zero
            while i < end {
                n += .one
                i = index(after: i)
            }
            return Index_Primitives.Index<Element>.Count(_unchecked: n)
        }
    }
}
