/// Bridge to `Swift.BidirectionalCollection` for `Copyable` conformers.
///
/// Types conforming to `Collection.Bidirectional`, `Collection.Protocol`,
/// and `Sequence.Protocol` that are `Copyable` can conform to
/// `Swift.BidirectionalCollection`:
///
/// ```swift
/// struct MyContainer: Collection.Bidirectional, Collection.`Protocol`,
///                     Sequence.`Protocol`, Swift.BidirectionalCollection {
///     // Requirements from all protocols satisfy Swift.BidirectionalCollection
/// }
/// ```
///
/// ## Why All Three Protocols Are Needed
///
/// `Swift.BidirectionalCollection` requires:
/// - Index navigation with `index(before:)` (from `Collection.Bidirectional`)
/// - Element access via `subscript` (from `Collection.Protocol`)
/// - `makeIterator()` (from `Sequence.Protocol`)
///
/// These are independent hierarchies in swift-primitives, so types must
/// conform to all three explicitly to bridge to `Swift.BidirectionalCollection`.
extension Collection.Bidirectional where Self: Copyable {
    // All index-navigation requirements satisfied by Collection.Bidirectional.
    // Types also need Collection.Protocol (subscript) and Sequence.Protocol (makeIterator)
    // to bridge to Swift.BidirectionalCollection.
}
