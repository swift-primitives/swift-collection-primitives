extension Collection {
    /// Tag type for `.map` property extensions.
    ///
    /// Use this tag with `Property.View` to add `.map` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding map to Your Type
    ///
    /// ```swift
    /// extension MyContainer {
    ///     var map: Property<Collection.Map, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.Map, MyContainer>.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.map { }` | Transform elements, returns `[U]` |
    public enum Map {}
}
