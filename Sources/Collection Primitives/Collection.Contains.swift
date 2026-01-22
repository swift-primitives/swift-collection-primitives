extension Collection {
    /// Tag type for `.contains` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.contains` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding contains to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var contains: Property<Collection.Contains, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.Contains, MyContainer>.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.contains { }` | Check if collection contains element matching predicate |
    public enum Contains {}
}
