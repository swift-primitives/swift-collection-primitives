extension Collection {
    /// Tag type for `.satisfies` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.satisfies` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding satisfies to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var satisfies: Property<Collection.Satisfies, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.Satisfies, MyContainer>.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.satisfies.all { }` | Check if all elements satisfy predicate |
    /// | `.satisfies.any { }` | Check if any element satisfies predicate |
    /// | `.satisfies.none { }` | Check if no elements satisfy predicate |
    public enum Satisfies {}
}
