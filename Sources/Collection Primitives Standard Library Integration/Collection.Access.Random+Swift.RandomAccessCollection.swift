/// Bridge to `Swift.RandomAccessCollection` for `Copyable` conformers.
///
/// A `Copyable` type conforming to `Collection.Access.Random` (and therefore
/// `Collection.Bidirectional` and `Collection.Protocol`) can conform to
/// `Swift.RandomAccessCollection` once it supplies a `Swift.Sequence`-compatible
/// `makeIterator()`:
///
/// ```swift
/// struct MyContainer: Collection.Access.Random, Swift.RandomAccessCollection {
///     // O(1) index arithmetic + a Swift.Sequence makeIterator() satisfy
///     // Swift.RandomAccessCollection.
/// }
/// ```
///
/// ## What `Swift.RandomAccessCollection` needs
///
/// `Swift.RandomAccessCollection` requires:
/// - O(1) index arithmetic (from `Collection.Access.Random`)
/// - Element access via `subscript` (from `Collection.Protocol`)
/// - a `Swift.Sequence`-compatible `makeIterator()`
///
/// `Collection.Protocol` refines `Iterable`, but the `Iterable` witness is a
/// borrowing *chunk* iterator, not the scalar `Swift.IteratorProtocol` that
/// `Swift.Sequence` consumes — so a `Copyable` conformer supplies a `Swift.Sequence`
/// `makeIterator()` to bridge.
extension Collection.Access.Random where Self: Copyable {
    // Index-navigation requirements are satisfied by Collection.Access.Random
    // (refining Collection.Bidirectional → Collection.Protocol); bridging to
    // Swift.RandomAccessCollection additionally needs a Swift.Sequence-compatible
    // makeIterator().
}
