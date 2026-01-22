public import Property_Primitives
public import Sequence_Primitives

/// Property.View extensions for borrowing iteration on `Collection.Protocol` conformers.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable, Tag == Collection.ForEach {

    /// Borrowing iteration: `.forEach { }`
    ///
    /// Iterates over all elements without consuming the collection.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach { print($0) }
    /// // container still has 3 elements
    /// ```
    ///
    /// - Parameter body: A closure called with each element.
    @inlinable
    public func callAsFunction(_ body: (Base.Element) -> Void) {
        var iterator = unsafe base.pointee.makeIterator()
        while let element = iterator.next() {
            body(element)
        }
    }

    /// Explicit borrowing iteration: `.forEach.borrowing { }`
    ///
    /// Same as `callAsFunction`, but with explicit naming for clarity.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach.borrowing { print($0) }
    /// // container still has 3 elements
    /// ```
    ///
    /// - Parameter body: A closure called with each element.
    @inlinable
    public func borrowing(_ body: (Base.Element) -> Void) {
        var iterator = unsafe base.pointee.makeIterator()
        while let element = iterator.next() {
            body(element)
        }
    }
}

/// Property.View extensions for consuming iteration on `Collection.Clearable` conformers.
extension Property.View
where Base: Collection.Clearable & ~Copyable, Tag == Collection.ForEach {

    /// Consuming iteration: `.forEach.consuming { }`
    ///
    /// Iterates over all elements and then clears the collection.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach.consuming { print($0) }
    /// // container is now empty
    /// ```
    ///
    /// - Parameter body: A closure called with each element.
    @_lifetime(&self)
    @inlinable
    public mutating func consuming(_ body: (Base.Element) -> Void) {
        var iterator = unsafe base.pointee.makeIterator()
        while let element = iterator.next() {
            body(element)
        }
        unsafe base.pointee.removeAll()
    }
}
