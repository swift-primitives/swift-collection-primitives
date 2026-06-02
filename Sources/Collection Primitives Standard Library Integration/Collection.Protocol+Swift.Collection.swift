/// Bridge to `Swift.Collection` for `Copyable` conformers.
///
/// A `Copyable` type conforming to `Collection.Protocol` can also conform to
/// `Swift.Collection` once it supplies a `Swift.Sequence`-compatible
/// `makeIterator()`:
///
/// ```swift
/// struct MyContainer: Collection.`Protocol`, Swift.Collection {
///     // Collection.Protocol's index requirements + a Swift.Sequence
///     // makeIterator() satisfy Swift.Collection.
/// }
/// ```
///
/// ## What `Swift.Collection` needs
///
/// `Swift.Collection` requires index-based access (provided by `Collection.Protocol`)
/// and a `Swift.Sequence`-compatible `makeIterator()`. `Collection.Protocol` refines
/// `Iterable`, but the `Iterable` witness is a borrowing *chunk* iterator
/// (`__IteratorChunkProtocol`), not the scalar `Swift.IteratorProtocol` that
/// `Swift.Sequence` consumes — so a `Copyable` conformer supplies a `Swift.Sequence`
/// `makeIterator()` (often forwarding to stdlib storage) to bridge.
///
/// ## Usage
///
/// ```swift
/// // 1. Define a Collection.Protocol conformer that vends a Swift.Sequence iterator.
/// struct Numbers: Collection.`Protocol` {
///     let values: [Int]
///
///     var startIndex: Index { .zero }
///     var endIndex: Index { Index(_unchecked: position: values.count) }
///     subscript(position: Index) -> Int { values[Int(bitPattern: position)] }
///     func index(after i: Index) -> Index { (i + Index.Offset(1))! }
///     func makeIterator() -> Array<Int>.Iterator { values.makeIterator() }
/// }
///
/// // 2. Add Swift.Collection conformance (no implementation needed).
/// extension Numbers: Swift.Collection {}
///
/// // 3. Now works with for-in, subscript ranges, and stdlib algorithms.
/// for n in Numbers(values: [1, 2, 3]) { print(n) }
/// ```
extension Collection.`Protocol` where Self: Copyable {
    // Index-based requirements are satisfied by Collection.Protocol; bridging to
    // Swift.Collection additionally needs a Swift.Sequence-compatible makeIterator().
}
