
extension Collection {
    /// Tag type and View for `.remove` operations.
    ///
    /// ## Adding remove to Your Type
    ///
    /// Conform to `Collection.Remove.Last` to get `.remove.last()`:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Remove.Last {
    ///     static func removeLast(_ base: inout Self) -> Element? {
    ///         guard !base.isEmpty else { return nil }
    ///         return base._storage.remove.last()
    ///     }
    /// }
    /// ```
    ///
    /// Conform to `Collection.Clearable` to also get `.remove.all()`:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Clearable {
    ///     static func removeAll(_ base: inout Self) {
    ///         base._storage.remove.all()
    ///     }
    /// }
    /// ```
    ///
    /// ## Available Operations
    ///
    /// | Operation | Requires |
    /// |-----------|----------|
    /// | `.remove.last()` | `Collection.Remove.Last` |
    /// | `.remove.all()` | `Collection.Clearable` |
    public enum Remove {}
}

extension Collection.Remove {
    /// View providing remove operations for `Collection.Remove.Last` conformers.
    @safe
    public struct View<Base: Collection.Remove.Last & ~Copyable>: ~Copyable, ~Escapable {
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

// MARK: - .remove.last()

extension Collection.Remove.View where Base: ~Copyable {
    /// Removes and returns the last element: `.remove.last()`
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.remove.last()  // Optional(3)
    /// container.remove.last()  // Optional(2)
    /// ```
    ///
    /// - Returns: The removed element, or `nil` if the collection is empty.
    @inlinable
    public mutating func last() -> Base.Element? {
        unsafe Base.removeLast(&_base.pointee)
    }
}

// MARK: - .remove.all()

extension Collection.Remove.View where Base: Collection.Clearable & ~Copyable {
    /// Removes all elements: `.remove.all()`
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.remove.all()
    /// container.count  // 0
    /// ```
    @inlinable
    public mutating func all() {
        unsafe Base.removeAll(&_base.pointee)
    }
}
