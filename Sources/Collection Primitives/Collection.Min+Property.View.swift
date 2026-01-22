public import Property_Primitives
public import Ordering_Primitives

/// Property.View extensions for finding minimum element on `Collection.Protocol` conformers.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable, Tag == Collection.Min {

    /// Find minimum element using comparator: `.min(by:)`
    ///
    /// Returns the minimum element according to the comparator, or `nil` if empty.
    ///
    /// ```swift
    /// var container = MyContainer([3, 1, 4, 1, 5])
    /// container.min(by: .ascending)  // Optional(1)
    /// container.min(by: .descending) // Optional(5)
    /// ```
    ///
    /// - Parameter comparator: The comparator defining the ordering.
    /// - Returns: The minimum element, or `nil` if the collection is empty.
    @inlinable
    public func callAsFunction(by comparator: Ordering.Comparator<Base.Element>) -> Base.Element? {
        var iterator = unsafe base.pointee.makeIterator()
        guard var result = iterator.next() else { return nil }
        while let element = iterator.next() {
            if comparator(element, result) == .less {
                result = element
            }
        }
        return result
    }
}

/// Property.View extensions for finding minimum element on collections with Comparison.Protocol elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable,
      Base.Element: Comparison.`Protocol`,
      Tag == Collection.Min {

    /// Find minimum element using natural ordering: `.min()`
    ///
    /// Returns the minimum element according to natural ascending order, or `nil` if empty.
    ///
    /// ```swift
    /// var numbers = MyContainer([3, 1, 4, 1, 5])
    /// numbers.min()  // Optional(1)
    /// ```
    ///
    /// - Returns: The minimum element, or `nil` if the collection is empty.
    @inlinable
    public func callAsFunction() -> Base.Element? {
        self(by: .ascending)
    }
}

/// Property.View extensions for finding minimum element on collections with Swift.Comparable elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable,
      Base.Element: Swift.Comparable,
      Tag == Collection.Min {

    /// Find minimum element using natural ordering: `.min()`
    ///
    /// Returns the minimum element according to natural ascending order, or `nil` if empty.
    ///
    /// ```swift
    /// var names = MyContainer(["Charlie", "Alice", "Bob"])
    /// names.min()  // Optional("Alice")
    /// ```
    ///
    /// - Returns: The minimum element, or `nil` if the collection is empty.
    @_disfavoredOverload
    @inlinable
    public func callAsFunction() -> Base.Element? {
        self(by: .ascending)
    }
}
