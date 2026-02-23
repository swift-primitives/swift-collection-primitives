extension Collection {
    /// Tag type for `.forEach` property extensions on collections.
    ///
    /// `Collection.ForEach` provides index-based iteration that enables true
    /// borrowing semantics via subscript `_read`. This shadows the inherited
    /// `Sequence.ForEach` default, which uses iterator-based iteration.
    ///
    /// The `.forEach` accessor is provided automatically via protocol default
    /// on `Collection.Protocol`. Conformers do not need to add it manually.
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.forEach { }` | Borrowing iteration via `callAsFunction` |
    /// | `.forEach.borrowing { }` | Explicit borrowing iteration |
    /// | `.forEach.consuming { }` | Consuming iteration (requires `Clearable`) |
    ///
    /// ## Collection.ForEach vs Sequence.ForEach
    ///
    /// `Collection.ForEach` uses index-based traversal for true borrowing
    /// semantics through subscript `_read`. `Sequence.ForEach` uses
    /// `makeIterator()` which copies elements through `next()`.
    ///
    /// The `Collection.Protocol` default shadows the inherited `Sequence.Protocol`
    /// default, so collection conformers always get the index-based implementation.
    public enum ForEach {}
}
