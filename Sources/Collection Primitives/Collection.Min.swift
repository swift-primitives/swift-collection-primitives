extension Collection {
    /// Tag type for `.min` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.min` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding min to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var min: Property<Collection.Min, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.Min, MyContainer>.View(&self)
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
