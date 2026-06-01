extension Collection {
    /// Protocol for collections that can be cleared, supporting `~Copyable`.
    ///
    /// Conformers implement the static `removeAll(_:)` primitive.
    /// The fluent API `.remove.all()` is provided automatically.
    ///
    /// ## Conforming to Collection.Clearable
    ///
    /// Implement the static `removeAll(_:)` primitive:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Clearable {
    ///     static func removeAll(_ base: inout Self) {
    ///         base._storage.remove.all()
    ///     }
    /// }
    /// ```
    ///
    /// ## Clearing
    ///
    /// Types conforming to `Collection.Clearable` get `.remove.all()` automatically
    /// via the `Collection.Remove` fluent surface. Combine it with the inherited
    /// `Iterable.forEach` for an iterate-then-clear sequence:
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach { element in    // inherited from Iterable (borrowing)
    ///     print(element)
    /// }
    /// container.remove.all()            // container is now empty
    /// ```
    public protocol Clearable: Collection.`Protocol` & ~Copyable {
        /// Removes all elements.
        ///
        /// Static implementation primitive. Use `.remove.all()` at call sites.
        static func removeAll(_ base: inout Self)
    }
}
