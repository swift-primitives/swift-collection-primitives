/// Bridge to `Swift.BidirectionalCollection` for `Copyable` conformers.
///
/// A `Copyable` type conforming to `Collection.Bidirectional` (and therefore
/// `Collection.Protocol`) can conform to `Swift.BidirectionalCollection` once it
/// supplies a `Swift.Sequence`-compatible `makeIterator()`:
///
/// ```swift
/// struct MyContainer: Collection.Bidirectional, Swift.BidirectionalCollection {
///     // index navigation + a Swift.Sequence makeIterator() satisfy
///     // Swift.BidirectionalCollection.
/// }
/// ```
///
/// ## What `Swift.BidirectionalCollection` needs
///
/// `Swift.BidirectionalCollection` requires:
/// - Index navigation with `index(before:)` (from `Collection.Bidirectional`)
/// - Element access via `subscript` (from `Collection.Protocol`, which
///   `Collection.Bidirectional` refines)
/// - a `Swift.Sequence`-compatible `makeIterator()`
///
/// `Collection.Protocol` refines `Iterable`, but the `Iterable` witness is a
/// borrowing *chunk* iterator, not the scalar `Swift.IteratorProtocol` that
/// `Swift.Sequence` consumes — so a `Copyable` conformer supplies a `Swift.Sequence`
/// `makeIterator()` to bridge.
extension Collection.Bidirectional where Self: Copyable {
    // Index-navigation requirements are satisfied by Collection.Bidirectional
    // (refining Collection.Protocol); bridging to Swift.BidirectionalCollection
    // additionally needs a Swift.Sequence-compatible makeIterator().
}
