extension Collection {
    /// Tag type and View for `.remove` operations.
    ///
    /// ## Adding remove to Your Type
    ///
    /// Conform to `Collection.Remove.Last` to get `.remove.last()`:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Remove.Last {
    ///     static func last(_ base: inout Self) -> Element? {
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
    // SAFETY: Encapsulates unsafe internals behind a safe API; see
    // SAFETY: [MEM-SAFE-024] for the absorber-pattern taxonomy.
    /// View providing remove operations for `Collection.Remove.Last` conformers.
    @safe
    public struct View<Base: Collection.Remove.Last & ~Copyable>: ~Copyable, ~Escapable {
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

// MARK: - .remove.last()

extension Collection.Remove.View where Base: ~Copyable {
    /// Removes and returns the last element via `.remove.last()`.
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
    /// Removes all elements via `.remove.all()`.
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
