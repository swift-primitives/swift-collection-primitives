extension Collection {
    /// Tag type for `.forEach` property extensions on collections.
    ///
    /// Use this tag with `Property.View` to add `.forEach` functionality
    /// to types conforming to `Collection.Protocol`.
    ///
    /// ## Adding forEach to Your Type
    ///
    /// 1. Conform to `Collection.Protocol`
    /// 2. Add a `forEach` property returning `Property<Collection.ForEach, Self>.View`
    ///
    /// ```swift
    /// extension MyContainer: Swift.Collection.Protocol {
    ///     // ... protocol requirements ...
    /// }
    ///
    /// extension MyContainer {
    ///     var forEach: Property<Collection.ForEach, MyContainer>.View {
    ///         mutating _read {
    ///             yield unsafe Property<Collection.ForEach, MyContainer>.View(&self)
    ///         }
    ///         mutating _modify {
    ///             var view = unsafe Property<Collection.ForEach, MyContainer>.View(&self)
    ///             yield &view
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// Once you add the `forEach` property, these operations are available
    /// via `Property.View` extensions:
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.forEach { }` | Borrowing iteration via `callAsFunction` |
    /// | `.forEach.borrowing { }` | Explicit borrowing iteration |
    /// | `.forEach.consuming { }` | Consuming iteration (requires `Clearable`) |
    ///
    /// ## Collection.ForEach vs Sequence.ForEach
    ///
    /// Use `Collection.ForEach` when your type conforms to `Collection.Protocol`.
    /// Use `Sequence.ForEach` when your type only conforms to `Sequence.Protocol`.
    /// Both provide the same iteration methods.
    public enum ForEach {}
}
