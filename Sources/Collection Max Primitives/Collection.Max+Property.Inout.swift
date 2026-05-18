public import Order_Primitives
public import Property_Primitives

// MARK: - Universal index-based max (works with ~Copyable elements)

/// Property.Inout extensions for finding maximum element index on `Collection.Protocol` conformers.
extension Property.Inout
where Base: Collection.`Protocol` & ~Copyable, Tag == Collection.Max {

    /// Find index of maximum element using comparator via `.max.index(by:)`.
    ///
    /// Returns the index of the maximum element according to the comparator,
    /// or `nil` if the collection is empty. Works with `~Copyable` elements.
    ///
    /// ```swift
    /// var container = MyContainer([3, 1, 4, 1, 5])
    /// if let idx = container.max.index(by: .ascending) {
    ///     print(container[idx])  // 5
    /// }
    /// ```
    ///
    /// - Parameter comparator: The comparator defining the ordering.
    /// - Returns: The index of the maximum element, or `nil` if empty.
    @inlinable
    public func index(by comparator: Order.Comparator<Base.Element>) -> Base.Index? {
        var index = base.value.startIndex
        let endIndex = base.value.endIndex
        guard index < endIndex else { return nil }
        var bestIndex = index
        index = base.value.index(after: index)
        while index < endIndex {
            if comparator(base.value[index], base.value[bestIndex]) == .greater {
                bestIndex = index
            }
            index = base.value.index(after: index)
        }
        return bestIndex
    }
}

/// Convenience `max.index()` for `Comparison.Protocol` elements.
extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Element: Comparison.`Protocol`,
    Tag == Collection.Max
{

    /// Find index of maximum element using natural ordering via `.max.index()`.
    ///
    /// - Returns: The index of the maximum element, or `nil` if empty.
    @inlinable
    public func index() -> Base.Index? {
        index(by: .ascending)
    }
}

#if swift(<6.4)
    /// Convenience `max.index()` for `Swift.Comparable` elements.
    ///
    /// Gated to Swift <6.4 because under 6.4+ `Comparison.Protocol` is a typealias
    /// to `Swift.Comparable` (SE-0499), making this extension a duplicate of the
    /// `Comparison.Protocol` one above. Under 6.4+, types conforming to
    /// `Swift.Comparable` automatically satisfy the `Comparison.Protocol`
    /// extension's constraint.
    extension Property.Inout
    where
        Base: Collection.`Protocol` & ~Copyable,
        Base.Element: Swift.Comparable,
        Tag == Collection.Max
    {

        /// Find index of maximum element using natural ordering via `.max.index()`.
        ///
        /// - Returns: The index of the maximum element, or `nil` if empty.
        @_disfavoredOverload
        @inlinable
        public func index() -> Base.Index? {
            index(by: .ascending)
        }
    }
#endif

// MARK: - Copyable element max value (returns Element via index + subscript)

/// Property.Inout extensions for finding maximum element on collections with Copyable elements.
extension Property.Inout
where Base: Collection.`Protocol` & ~Copyable, Base.Element: Copyable, Tag == Collection.Max {

    /// Find maximum element using comparator via `.max(by:)`.
    ///
    /// Returns the maximum element according to the comparator, or `nil` if empty.
    /// Requires `Element: Copyable` to return the element by value.
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
    public func callAsFunction(by comparator: Order.Comparator<Base.Element>) -> Base.Element? {
        guard let idx = index(by: comparator) else { return nil }
        return base.value[idx]
    }
}

/// Property.Inout extensions for finding maximum element on collections with Comparison.Protocol elements.
extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Element: Copyable & Comparison.`Protocol`,
    Tag == Collection.Max
{

    /// Find maximum element using natural ordering via `.max()`.
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

#if swift(<6.4)
    /// Property.Inout extensions for finding maximum element on collections with Swift.Comparable elements.
    ///
    /// Gated to Swift <6.4 — see the matching `index()` overload above for the
    /// SE-0499 unification rationale.
    extension Property.Inout
    where
        Base: Collection.`Protocol` & ~Copyable,
        Base.Element: Copyable & Swift.Comparable,
        Tag == Collection.Max
    {

        /// Find maximum element using natural ordering via `.max()`.
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
#endif
