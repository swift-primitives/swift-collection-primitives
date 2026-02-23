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
    /// Conformers implement the static `removeLast(_:)` primitive.
    /// The fluent API `.remove.last()` is provided automatically
    /// via protocol extension.
    ///
    /// ## Conforming to Collection.Remove.Last
    ///
    /// Implement the static `removeLast(_:)` primitive:
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
    public protocol Last: Collection.`Protocol` & ~Copyable {
        /// Removes and returns the last element, or `nil` if empty.
        ///
        /// Static implementation primitive. Use `.remove.last()` at call sites.
        static func removeLast(_ base: inout Self) -> Element?
    }
}
