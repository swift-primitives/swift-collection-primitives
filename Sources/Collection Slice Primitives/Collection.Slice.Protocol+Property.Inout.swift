public import Property_Primitives

/// Automatic `.slice` accessor for `Collection.Slice.Protocol` conformers.
///
/// Provides access to additional slice operations via `Property.Inout`.
extension Collection.Slice.`Protocol` where Self: ~Copyable {
    /// Access slice operations via fluent API.
    @inlinable
    public var slice: Property<Collection.Slice, Self>.Inout {
        mutating _read {
            yield Property<Collection.Slice, Self>.Inout(&self)
        }
    }
}
