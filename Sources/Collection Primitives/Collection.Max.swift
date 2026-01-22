extension Collection {
    /// Tag type for `.max` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.max` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding max to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var max: Property<Collection.Max, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.Max, MyContainer>.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.max(by:)` | Find maximum element using comparator |
    /// | `.max()` | Find maximum element (requires Comparison.Protocol) |
    public enum Max {}
}
