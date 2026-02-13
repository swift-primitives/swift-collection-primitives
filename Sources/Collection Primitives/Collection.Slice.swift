extension Collection {
    /// Tag type for `.slice` property extensions.
    ///
    /// Also serves as namespace for `Collection.Slice.Protocol`.
    ///
    /// ## Protocol
    ///
    /// `Collection.Slice.Protocol` extends `Collection.Protocol` with
    /// self-slicing: `subscript(bounds: Range<Index>) -> Self`.
    ///
    /// ## Property.View Operations
    ///
    /// Conformers to `Collection.Slice.Protocol` automatically receive
    /// a `.slice` accessor for additional operations via `Property.View`.
    ///
    /// ## Default Extensions
    ///
    /// Conformers automatically receive:
    /// - `subscript(PartialRangeFrom<Index>)` — `self[i...]`
    /// - `subscript(PartialRangeUpTo<Index>)` — `self[..<i]`
    public enum Slice {}
}
