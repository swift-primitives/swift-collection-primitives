/// Bridge to `Swift.RandomAccessCollection` for `Copyable` conformers.
///
/// Types conforming to `Collection.Access.Random`, `Collection.Protocol`,
/// and `Sequence.Protocol` that are `Copyable` can conform to
/// `Swift.RandomAccessCollection`:
///
/// ```swift
/// struct MyContainer: Collection.Access.Random, Collection.`Protocol`,
///                     Sequence.`Protocol`, Swift.RandomAccessCollection {
///     // Requirements from all protocols satisfy Swift.RandomAccessCollection
/// }
/// ```
///
/// ## Why All Three Protocols Are Needed
///
/// `Swift.RandomAccessCollection` requires:
/// - O(1) index arithmetic (from `Collection.Access.Random`)
/// - Element access via `subscript` (from `Collection.Protocol`)
/// - `makeIterator()` (from `Sequence.Protocol`)
///
/// These are independent hierarchies in swift-primitives, so types must
/// conform to all three explicitly to bridge to `Swift.RandomAccessCollection`.
extension Collection.Access.Random where Self: Copyable {
    // All index-navigation requirements satisfied by Collection.Access.Random.
    // Types also need Collection.Protocol (subscript) and Sequence.Protocol (makeIterator)
    // to bridge to Swift.RandomAccessCollection.
}
