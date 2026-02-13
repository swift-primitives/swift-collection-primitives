public import Property_Primitives

/// Automatic `.slice` accessor for `Collection.Slice.Protocol` conformers.
///
/// Provides access to additional slice operations via `Property.View`.
extension Collection.Slice.`Protocol` where Self: ~Copyable {
    @inlinable
    public var slice: Property<Collection.Slice, Self>.View {
        mutating _read {
            yield unsafe Property<Collection.Slice, Self>.View(&self)
        }
    }
}
