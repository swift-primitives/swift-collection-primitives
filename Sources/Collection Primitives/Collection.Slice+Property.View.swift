import Property_Primitives

/// Property.View extensions for slice operations on `Collection.Slice.Protocol` conformers.
///
/// These operations are available via the `.slice` accessor on any conformer.
/// Additional operations can be added here as needed.
extension Property.View
where Base: Collection.Slice.`Protocol` & ~Copyable, Tag == Collection.Slice {
    // Reserved for future operations:
    // - prefix(count:) -> Base
    // - suffix(count:) -> Base
    // - split(separator:) -> [Base]
}
