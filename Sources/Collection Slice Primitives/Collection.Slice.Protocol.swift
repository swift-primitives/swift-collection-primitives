extension Collection.Slice {
    // Slicing is range-based (`Range<Index>`), and stdlib `Range<Bound>` stores its two
    // bounds by value, so it requires `Bound: Escapable`. A slicing collection's `Index`
    // must therefore be `Comparable & Escapable`; the default `Index<Element>` is, and
    // `~Escapable` / custom-domain indices are excluded from slicing by design (a self-
    // slice would have to store its bound positions — impossible for a ~Escapable index).
    // On Swift ≤6.3 `Comparable` implied `Escapable`, so `& Escapable` was implicit;
    // SE-0499 relaxed `Comparable` to admit `~Escapable`, so it must now be spelled out.
    /// A collection that can produce sub-ranges of itself.
    ///
    /// `Collection.Slice.Protocol` extends `Collection.Protocol` with a single
    /// requirement: a range subscript that returns `Self`. This models
    /// "self-slicing" — the stdlib equivalent of `SubSequence == Self`.
    ///
    /// ## Conforming
    ///
    /// Implement the range subscript to return a narrowed view of the same type:
    ///
    /// ```swift
    /// extension MyCollection: Collection.Slice.`Protocol` {
    ///     subscript(bounds: Range<Index>) -> Self {
    ///         MyCollection(base: storage, start: bounds.lowerBound, end: bounds.upperBound)
    ///     }
    /// }
    /// ```
    ///
    /// ## Default Extensions
    ///
    /// Conformers automatically receive partial-range subscripts:
    ///
    /// ```swift
    /// let prefix = collection[..<endIndex]     // PartialRangeUpTo
    /// let suffix = collection[startIndex...]    // PartialRangeFrom
    /// ```
    public protocol `Protocol`: Collection.`Protocol` & ~Copyable where Index: Swift.Comparable & Swift.Escapable {
        /// Accesses a contiguous sub-range of the collection.
        ///
        /// Returns `Self` — this is a self-slicing collection.
        ///
        /// - Parameter bounds: A range of valid indices.
        /// - Returns: A value of the same type representing the sub-range.
        subscript(bounds: Range<Index>) -> Self { get }
    }
}
