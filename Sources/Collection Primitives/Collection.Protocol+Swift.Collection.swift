/// Bridge to `Swift.Collection` for `Copyable` conformers.
///
/// Types conforming to `Collection.Protocol` that are `Copyable` can also
/// conform to `Swift.Collection` with no additional implementation:
///
/// ```swift
/// struct MyContainer: Collection.`Protocol`, Swift.Collection {
///     // Collection.Protocol requirements satisfy Swift.Collection
/// }
/// ```
///
/// ## Why This Works
///
/// `Collection.Protocol` requires:
/// - `associatedtype Index: Comparable`
/// - `var startIndex: Index`
/// - `var endIndex: Index`
/// - `subscript(position: Index) -> Element`
/// - `func index(after i: Index) -> Index`
/// - `func makeIterator() -> Iterator` (from `Sequence.Protocol`)
///
/// These satisfy `Swift.Collection`'s requirements exactly.
///
/// ## Usage
///
/// ```swift
/// // 1. Define your type with Collection.Protocol
/// struct Numbers: Collection.`Protocol` {
///     let values: [Int]
///
///     var startIndex: Int { values.startIndex }
///     var endIndex: Int { values.endIndex }
///     subscript(position: Int) -> Int { values[position] }
///     func index(after i: Int) -> Int { i + 1 }
///     func makeIterator() -> Array<Int>.Iterator { values.makeIterator() }
/// }
///
/// // 2. Add Swift.Collection conformance (no implementation needed)
/// extension Numbers: Swift.Collection {}
///
/// // 3. Now works with for-in, subscript ranges, and stdlib algorithms
/// for n in Numbers(values: [1, 2, 3]) { print(n) }
/// let slice = numbers[1..<3]
/// ```
extension Collection.`Protocol` where Self: Copyable {
    // All requirements satisfied by Collection.Protocol.
    // This extension enables documentation and future default implementations.
}
