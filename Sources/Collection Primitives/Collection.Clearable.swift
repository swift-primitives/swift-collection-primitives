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
    /// ## Consuming Iteration
    ///
    /// Types conforming to `Collection.Clearable` get `.forEach.consuming { }`
    /// automatically via the `Property.View` extension:
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach.consuming { element in
    ///     print(element)
    /// }
    /// // container is now empty
    /// ```
    public protocol Clearable: Collection.`Protocol` & ~Copyable {
        /// Removes all elements.
        ///
        /// Static implementation primitive. Use `.remove.all()` at call sites.
        static func removeAll(_ base: inout Self)
    }
}
