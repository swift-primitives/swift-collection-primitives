public import Property_Primitives
public import Ordering_Primitives

/// Property.View extensions for finding maximum element on `Collection.Protocol` conformers.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable, Tag == Collection.Max {

    /// Find maximum element using comparator: `.max(by:)`
    ///
    /// Returns the maximum element according to the comparator, or `nil` if empty.
    ///
    /// ```swift
    /// var container = MyContainer([3, 1, 4, 1, 5])
    /// container.max(by: .ascending)  // Optional(5)
    /// container.max(by: .descending) // Optional(1)
    /// ```
    ///
    /// - Parameter comparator: The comparator defining the ordering.
    /// - Returns: The maximum element, or `nil` if the collection is empty.
    @inlinable
    public func callAsFunction(by comparator: Ordering.Comparator<Base.Element>) -> Base.Element? {
        var iterator = unsafe base.pointee.makeIterator()
        guard var result = iterator.next() else { return nil }
        while let element = iterator.next() {
            if comparator(element, result) == .greater {
                result = element
            }
        }
        return result
    }
}

/// Property.View extensions for finding maximum element on collections with Comparison.Protocol elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable,
      Base.Element: Comparison.`Protocol`,
      Tag == Collection.Max {

    /// Find maximum element using natural ordering: `.max()`
    ///
    /// Returns the maximum element according to natural ascending order, or `nil` if empty.
    ///
    /// ```swift
    /// var numbers = MyContainer([3, 1, 4, 1, 5])
    /// numbers.max()  // Optional(5)
    /// ```
    ///
    /// - Returns: The maximum element, or `nil` if the collection is empty.
    @inlinable
    public func callAsFunction() -> Base.Element? {
        self(by: .ascending)
    }
}

/// Property.View extensions for finding maximum element on collections with Swift.Comparable elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable,
      Base.Element: Swift.Comparable,
      Tag == Collection.Max {

    /// Find maximum element using natural ordering: `.max()`
    ///
    /// Returns the maximum element according to natural ascending order, or `nil` if empty.
    ///
    /// ```swift
    /// var names = MyContainer(["Charlie", "Alice", "Bob"])
    /// names.max()  // Optional("Charlie")
    /// ```
    ///
    /// - Returns: The maximum element, or `nil` if the collection is empty.
    @_disfavoredOverload
    @inlinable
    public func callAsFunction() -> Base.Element? {
        self(by: .ascending)
    }
}
