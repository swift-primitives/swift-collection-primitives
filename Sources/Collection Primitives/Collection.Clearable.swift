public import Sequence_Primitives

extension Collection {
    /// Protocol for collections that can be cleared, supporting `~Copyable`.
    ///
    /// `Collection.Clearable` combines `Collection.Protocol` with
    /// `Sequence.Clearable`, enabling consuming iteration via
    /// `.forEach.consuming { }`.
    ///
    /// ## Conforming to Collection.Clearable
    ///
    /// Conform to `Collection.Protocol` and implement `removeAll()`:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Clearable {
    ///     // Collection.Protocol requirements...
    ///
    ///     mutating func removeAll() {
    ///         storage.removeAll()
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
    public protocol Clearable: Collection.`Protocol` & Sequence_Primitives.Sequence.Clearable & ~Copyable {}
}
