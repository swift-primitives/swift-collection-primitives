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
    /// Conform to `Collection.Clearable` to also get `.remove.all()`:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Clearable {
    ///     static func removeAll(_ base: inout Self) {
    ///         base._storage.remove.all()
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Requires |
    /// |-----------|----------|
    /// | `.remove.last()` | `Collection.Remove.Last` |
    /// | `.remove.all()` | `Collection.Clearable` |
    public enum Remove {}
}
