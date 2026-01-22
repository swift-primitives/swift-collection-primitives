extension Collection {
    /// Tag type for `.reduce` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.reduce` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding reduce to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var reduce: Property<Collection.Reduce, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.Reduce, MyContainer>.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.reduce.into(_:) { }` | Reduce with mutable accumulator |
    /// | `.reduce.from(_:) { }` | Reduce with immutable accumulator |
    public enum Reduce {}
}
