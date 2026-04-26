public import Property_Primitives
public import Order_Primitives

// MARK: - Universal index-based min (works with ~Copyable elements)

/// Property.View extensions for finding minimum element index on `Collection.Protocol` conformers.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable, Tag == Collection.Min {

    /// Find index of minimum element using comparator: `.min.index(by:)`
    ///
    /// Returns the index of the minimum element according to the comparator,
    /// or `nil` if the collection is empty. Works with `~Copyable` elements.
    ///
    /// ```swift
    /// var container = MyContainer([3, 1, 4, 1, 5])
    /// if let idx = container.min.index(by: .ascending) {
    ///     print(container[idx])  // 1
    /// }
    /// ```
    ///
    /// - Parameter comparator: The comparator defining the ordering.
    /// - Returns: The index of the minimum element, or `nil` if empty.
    @inlinable
    public func index(by comparator: Order.Comparator<Base.Element>) -> Base.Index? {
        var index = unsafe base.value.startIndex
        let endIndex = unsafe base.value.endIndex
        guard index < endIndex else { return nil }
        var bestIndex = index
        index = unsafe base.value.index(after: index)
        while index < endIndex {
            if comparator(unsafe base.value[index], unsafe base.value[bestIndex]) == .less {
                bestIndex = index
            }
            index = unsafe base.value.index(after: index)
        }
        return bestIndex
    }
}

/// Convenience `min.index()` for `Comparison.Protocol` elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable,
      Base.Element: Comparison.`Protocol`,
      Tag == Collection.Min {

    /// Find index of minimum element using natural ordering: `.min.index()`
    ///
    /// - Returns: The index of the minimum element, or `nil` if empty.
    @inlinable
    public func index() -> Base.Index? {
        index(by: .ascending)
    }
}

/// Convenience `min.index()` for `Swift.Comparable` elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable,
      Base.Element: Swift.Comparable,
      Tag == Collection.Min {

    /// Find index of minimum element using natural ordering: `.min.index()`
    ///
    /// - Returns: The index of the minimum element, or `nil` if empty.
    @_disfavoredOverload
    @inlinable
    public func index() -> Base.Index? {
        index(by: .ascending)
    }
}

// MARK: - Copyable element min value (returns Element via index + subscript)

/// Property.View extensions for finding minimum element on collections with Copyable elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable, Base.Element: Copyable, Tag == Collection.Min {

    /// Find minimum element using comparator: `.min(by:)`
    ///
    /// Returns the minimum element according to the comparator, or `nil` if empty.
    /// Requires `Element: Copyable` to return the element by value.
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
    public func callAsFunction(by comparator: Order.Comparator<Base.Element>) -> Base.Element? {
        guard let idx = index(by: comparator) else { return nil }
        return unsafe base.value[idx]
    }
}

/// Property.View extensions for finding minimum element on collections with Comparison.Protocol elements.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable,
      Base.Element: Copyable & Comparison.`Protocol`,
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
      Base.Element: Copyable & Swift.Comparable,
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
