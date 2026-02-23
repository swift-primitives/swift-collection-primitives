/// Bridge to `Swift.Collection` for `Copyable` conformers.
///
/// Types conforming to both `Collection.Protocol` and `Sequence.Protocol`
/// that are `Copyable` can also conform to `Swift.Collection`:
///
/// ```swift
/// struct MyContainer: Collection.`Protocol`, Sequence.`Protocol`, Swift.Collection {
///     // Collection.Protocol + Sequence.Protocol requirements satisfy Swift.Collection
/// }
/// ```
///
/// ## Why Both Protocols Are Needed
///
/// `Swift.Collection` requires both index-based access (from `Collection.Protocol`)
/// and `makeIterator()` (from `Sequence.Protocol`). Since `Collection.Protocol`
/// no longer inherits from `Sequence.Protocol`, types must conform to both
/// explicitly to bridge to `Swift.Collection`.
///
/// ## Usage
///
/// ```swift
/// // 1. Define your type with both protocols
/// struct Numbers: Collection.`Protocol`, Sequence.`Protocol` {
///     let values: [Int]
///
///     var startIndex: Index { .zero }
///     var endIndex: Index { Index(__unchecked: (), position: values.count) }
///     subscript(position: Index) -> Int { values[Int(bitPattern: position)] }
///     func index(after i: Index) -> Index { (i + Index.Offset(1))! }
///     func makeIterator() -> Array<Int>.Iterator { values.makeIterator() }
/// }
///
/// // 2. Add Swift.Collection conformance (no implementation needed)
/// extension Numbers: Swift.Collection {}
///
/// // 3. Now works with for-in, subscript ranges, and stdlib algorithms
/// for n in Numbers(values: [1, 2, 3]) { print(n) }
/// ```
extension Collection.`Protocol` where Self: Copyable {
    // All index-based requirements satisfied by Collection.Protocol.
    // Types also need Sequence.Protocol for makeIterator() to bridge to Swift.Collection.
}
