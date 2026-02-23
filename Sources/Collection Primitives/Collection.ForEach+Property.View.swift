public import Property_Primitives

/// Property.View extensions for borrowing iteration on `Collection.Protocol` conformers.
///
/// Uses index-based iteration instead of `makeIterator()` to enable true borrowing
/// semantics via subscript `_read`. This supports both Copyable and ~Copyable elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable, Tag == Collection.ForEach {

    /// Borrowing iteration: `.forEach { }`
    ///
    /// Iterates over all elements without consuming the collection.
    /// Uses index-based access for true borrowing semantics.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach { print($0) }
    /// // container still has 3 elements
    /// ```
    ///
    /// - Parameter body: A closure called with each element.
    @inlinable
    public func callAsFunction(_ body: (borrowing Base.Element) -> Void) {
        var index = unsafe base.pointee.startIndex
        let endIndex = unsafe base.pointee.endIndex
        while index < endIndex {
            body(unsafe base.pointee[index])
            index = unsafe base.pointee.index(after: index)
        }
    }

    /// Explicit borrowing iteration: `.forEach.borrowing { }`
    ///
    /// Same as `callAsFunction`, but with explicit naming for clarity.
    /// Uses index-based access for true borrowing semantics.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.forEach.borrowing { print($0) }
    /// // container still has 3 elements
    /// ```
    ///
    /// - Parameter body: A closure called with each element.
    @inlinable
    public func borrowing(_ body: (borrowing Base.Element) -> Void) {
        var index = unsafe base.pointee.startIndex
        let endIndex = unsafe base.pointee.endIndex
        while index < endIndex {
            body(unsafe base.pointee[index])
            index = unsafe base.pointee.index(after: index)
        }
    }
}

/// Property.View extensions for consuming iteration on `Collection.Clearable` conformers.
extension Property.View
where Base: Collection.Clearable & ~Copyable, Tag == Collection.ForEach {

    /// Consuming iteration: `.forEach.consuming { }`
    ///
    /// Iterates over all elements and then clears the collection.
    /// Uses index-based access for true borrowing during iteration.
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
    public mutating func consuming(_ body: (borrowing Base.Element) -> Void) {
        var index = unsafe base.pointee.startIndex
        let endIndex = unsafe base.pointee.endIndex
        while index < endIndex {
            body(unsafe base.pointee[index])
            index = unsafe base.pointee.index(after: index)
        }
        unsafe Base.removeAll(&base.pointee)
    }
}
