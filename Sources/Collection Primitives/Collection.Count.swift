public import Index_Primitives

// MARK: - Protocol Extension Provides .count Property Automatically

/// Types conforming to `Collection.Protocol` automatically get the `.count` property.
extension Collection.`Protocol` where Self: ~Copyable {
    /// Access counting operations via fluent API.
    ///
    /// This property is provided automatically by protocol extension.
    /// Conformers do not need to implement it.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3, 4, 5])
    /// container.count.all        // Count(5)
    /// container.count.where { }  // Count matching predicate
    /// ```
    public var count: Collection.Count.View<Self> {
        mutating _read {
            yield unsafe Collection.Count.View(&self)
        }
    }
}

// MARK: - Tag and View Definition

extension Collection {
    /// Tag type and View for `.count` operations.
    ///
    /// ## Adding count to Your Type
    ///
    /// ```swift
    /// extension MyContainer where Self: ~Copyable {
    ///     var count: Collection.Count.View<Self> {
    ///         mutating _read {
    ///             yield unsafe Collection.Count.View(&self)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Description |
    /// |-----------|-------------|
    /// | `.count.where { }` | Count elements matching predicate |
    /// | `.count.all` | Count all elements |
    public enum Count {}
}

extension Collection.Count {
    /// View providing count operations for `Collection.Protocol` conformers.
    @safe
    public struct View<Base: Collection.`Protocol` & ~Copyable>: ~Copyable, ~Escapable {
        @usableFromInline
        internal let _base: UnsafeMutablePointer<Base>

        @inlinable
        @_lifetime(borrow base)
        public init(_ base: UnsafeMutablePointer<Base>) {
            unsafe _base = base
        }

        @inlinable
        public var base: UnsafeMutablePointer<Base> { unsafe _base }
    }
}

extension Collection.Count.View {
    /// Count elements matching predicate: `.count.where { }`
    ///
    /// Returns the number of elements satisfying the predicate.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3, 4, 5, 6])
    /// let evenCount = container.count.where { $0 % 2 == 0 }  // Count(3)
    /// ```
    ///
    /// - Parameter predicate: A closure that returns `true` for elements to count.
    /// - Returns: The count of matching elements.
    @inlinable
    public func `where`(_ predicate: (borrowing Base.Element) -> Bool) -> Index<Base.Element>.Count {
        var count = Cardinal.zero
        var iterator = unsafe base.pointee.makeIterator()
        while let element = iterator.next() {
            if predicate(element) { count += .one }
        }
        return Index<Base.Element>.Count(__unchecked: (), count)
    }

    /// Count all elements: `.count.all`
    ///
    /// Returns the total number of elements in the collection.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3, 4, 5])
    /// let total = container.count.all  // Count(5)
    /// ```
    @inlinable
    public var all: Index<Base.Element>.Count {
        var count = Cardinal.zero
        var iterator = unsafe base.pointee.makeIterator()
        while iterator.next() != nil { count += .one }
        return Index<Base.Element>.Count(__unchecked: (), count)
    }
}
