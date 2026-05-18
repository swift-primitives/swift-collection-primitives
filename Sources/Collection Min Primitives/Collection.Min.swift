extension Collection {
    /// Tag type for `.min` property extensions.
    ///
    /// Use this tag with `Property.Inout` to add `.min` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding min to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var min: Property<Collection.Min, MyContainer>.Inout {
    ///         mutating _read {
    ///             yield Property<Collection.Min, MyContainer>.Inout(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.min(by:)` | Find minimum element using comparator |
    /// | `.min()` | Find minimum element (requires Comparison.Protocol) |
    public enum Min {}
}
