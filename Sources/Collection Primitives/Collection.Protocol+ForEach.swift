public import Property_Primitives

extension Collection.`Protocol` where Self: ~Copyable {
    /// Access iteration operations via fluent API.
    ///
    /// This property is provided automatically by protocol extension.
    /// Conformers do not need to implement it.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach { print($0) }            // borrowing
    /// container.forEach.borrowing { print($0) }  // explicit borrowing
    /// ```
    @inlinable
    public var forEach: Property<Collection.ForEach, Self>.View {
        mutating _read {
            yield unsafe Property<Collection.ForEach, Self>.View(&self)
        }
        mutating _modify {
            var view = unsafe Property<Collection.ForEach, Self>.View(&self)
            yield &view
        }
    }
}
