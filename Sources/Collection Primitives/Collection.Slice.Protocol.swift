extension Collection.Slice {
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
    public protocol `Protocol`: Collection.`Protocol` & ~Copyable {
        /// Accesses a contiguous sub-range of the collection.
        ///
        /// Returns `Self` — this is a self-slicing collection.
        ///
        /// - Parameter bounds: A range of valid indices.
        /// - Returns: A value of the same type representing the sub-range.
        subscript(bounds: Range<Index>) -> Self { get }
    }
}
