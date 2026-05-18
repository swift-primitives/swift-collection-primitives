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
    // SAFETY: Encapsulates unsafe internals behind a safe API; see
    // SAFETY: [MEM-SAFE-024] for the absorber-pattern taxonomy.
    /// View providing count operations for `Collection.Protocol` conformers.
    @safe
    public struct View<Base: Collection.`Protocol` & ~Copyable>: ~Copyable, ~Escapable {
        @usableFromInline
        internal let _base: UnsafeMutablePointer<Base>

        /// Creates a view bound to the given base pointer.
        @inlinable
        @_lifetime(borrow base)
        public init(_ base: UnsafeMutablePointer<Base>) {
            unsafe _base = base
        }
    }
}

extension Collection.Count.View {
    /// Count elements matching predicate via `.count.where { }`.
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
        var index = unsafe _base.pointee.startIndex
        let endIndex = unsafe _base.pointee.endIndex
        while index < endIndex {
            if predicate(unsafe _base.pointee[index]) { count += .one }
            index = unsafe _base.pointee.index(after: index)
        }
        return Index<Base.Element>.Count(_unchecked: count)
    }

    /// Count all elements via `.count.all`.
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
        var index = unsafe _base.pointee.startIndex
        let endIndex = unsafe _base.pointee.endIndex
        while index < endIndex {
            count += .one
            index = unsafe _base.pointee.index(after: index)
        }
        return Index<Base.Element>.Count(_unchecked: count)
    }
}
