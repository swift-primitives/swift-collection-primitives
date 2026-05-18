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
    public var forEach: Property<Collection.ForEach, Self>.Inout {
        mutating _read {
            yield Property<Collection.ForEach, Self>.Inout(&self)
        }
        mutating _modify {
            var accessor = Property<Collection.ForEach, Self>.Inout(&self)
            yield &accessor
        }
    }
}
