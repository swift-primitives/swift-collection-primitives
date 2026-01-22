extension Collection {
    /// Tag type for `.first` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.first` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding first to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var first: Property<Collection.First, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.First, MyContainer>.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.first { }` | Find first element matching predicate |
    public enum First {}
}
