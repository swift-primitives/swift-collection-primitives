extension Collection {
    /// Tag type for `.forEach` property extensions on collections.
    ///
    /// `Collection.ForEach` provides index-based iteration that enables true
    /// borrowing semantics via subscript `_read`. This is the collection
    /// iteration mechanism — collections iterate by index traversal, not
    /// by `makeIterator()` / `next()`.
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
    /// ## Why Index-Based
    ///
    /// Index-based traversal (`startIndex`, `index(after:)`, `subscript`)
    /// enables true borrowing semantics through subscript `_read`.
    /// Iterator-based traversal (`next() -> Element?`) returns owned values,
    /// which requires `Element: Copyable` or consuming moves.
    public enum ForEach {}
}
