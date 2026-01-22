extension Collection {
    /// Tag type for `.count` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.count` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding count to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var count: Property<Collection.Count, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.Count, MyContainer>.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.count.where { }` | Count elements matching predicate |
    /// | `.count.all` | Count all elements |
    public enum Count {}
}
