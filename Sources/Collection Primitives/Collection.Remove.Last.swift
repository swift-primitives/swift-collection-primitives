// MARK: - Protocol Extension Provides .remove Property Automatically

/// Types conforming to `Collection.Remove.Last` automatically get the `.remove` property.
extension Collection.Remove.Last where Self: ~Copyable {
    /// Access removal operations via fluent API.
    ///
    /// This property is provided automatically by protocol extension.
    /// Conformers do not need to implement it.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.remove.last()  // Optional(3)
    /// ```
    public var remove: Collection.Remove.View<Self> {
        mutating _read {
            yield unsafe Collection.Remove.View(&self)
        }
        mutating _modify {
            var view = unsafe Collection.Remove.View(&self)
            yield &view
        }
    }
}

// MARK: - Protocol Definition

extension Collection.Remove {
    /// Protocol for collections that support removing the last element.
    ///
    /// `Collection.Remove.Last` provides the primitive `removeLast()` method.
    /// Conformers automatically get the `.remove` property and `.remove.last()`
    /// fluent API via protocol extension.
    ///
    /// ## Conforming to Collection.Remove.Last
    ///
    /// Implement the `removeLast()` primitive:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Remove.Last {
    ///     mutating func removeLast() -> Element? {
    ///         guard !storage.isEmpty else { return nil }
    ///         return storage.removeLast()
    ///     }
    /// }
    /// ```
    ///
    /// ## Automatic Fluent API
    ///
    /// Conformers automatically get `.remove.last()` via protocol extension:
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3])
    /// container.remove.last()  // Optional(3)
    /// container.remove.last()  // Optional(2)
    /// container.remove.last()  // Optional(1)
    /// container.remove.last()  // nil
    /// ```
    ///
    /// ## Combining with Clearable
    ///
    /// For `.remove.all()`, also conform to `Collection.Clearable`:
    ///
    /// ```swift
    /// extension MyContainer: Collection.Remove.Last, Collection.Clearable {
    ///     mutating func removeLast() -> Element? { ... }
    ///     mutating func removeAll() { storage.removeAll() }
    /// }
    ///
    /// // Now both are available:
    /// container.remove.last()  // Remove one
    /// container.remove.all()   // Remove all
    /// ```
    public protocol Last: Collection.`Protocol` & ~Copyable {
        /// Removes and returns the last element, or `nil` if empty.
        ///
        /// This is the primitive operation. The fluent API `.remove.last()`
        /// is provided automatically via protocol extension.
        ///
        /// - Returns: The removed element, or `nil` if the collection is empty.
        mutating func removeLast() -> Element?
    }
}
