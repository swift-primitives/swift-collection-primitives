extension Collection {
    /// Tag type and View for `.remove` operations.
    ///
    /// ## Adding remove to Your Type
    ///
    /// Conform to `Collection.Remove.Last` to get `.remove.last()`:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Remove.Last {
    ///     static func last(_ base: inout Self) -> Element? {
    ///         guard !base.isEmpty else { return nil }
    ///         return base._storage.remove.last()
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Requires |
    /// |-----------|----------|
    /// | `.remove.last()` | `Collection.Remove.Last` |
    public enum Remove {}
}
