/// Bridge to `Swift.BidirectionalCollection` for `Copyable` conformers.
///
/// Types conforming to `Collection.Bidirectional` that are `Copyable` can also
/// conform to `Swift.BidirectionalCollection` with no additional implementation:
///
/// ```swift
/// struct MyContainer: Collection.Bidirectional, Swift.BidirectionalCollection {
///     // Collection.Bidirectional requirements satisfy Swift.BidirectionalCollection
/// }
/// ```
///
/// ## Why This Works
///
/// `Collection.Bidirectional` requires `index(before:)` in addition to
/// `Collection.Protocol` requirements. This is exactly what
/// `Swift.BidirectionalCollection` adds to `Swift.Collection`.
///
/// ## Usage
///
/// ```swift
/// // 1. Define your type with Collection.Bidirectional
/// struct Numbers: Collection.Bidirectional {
///     let values: [Int]
///
///     var startIndex: Int { values.startIndex }
///     var endIndex: Int { values.endIndex }
///     subscript(position: Int) -> Int { values[position] }
///     func index(after i: Int) -> Int { i + 1 }
///     func index(before i: Int) -> Int { i - 1 }
///     func makeIterator() -> Array<Int>.Iterator { values.makeIterator() }
/// }
///
/// // 2. Add Swift.BidirectionalCollection conformance
/// extension Numbers: Swift.BidirectionalCollection {}
///
/// // 3. Now works with reversed(), last, suffix(), etc.
/// let reversed = numbers.reversed()
/// let last = numbers.last
/// ```
extension Collection.Bidirectional where Self: Copyable {
    // All requirements satisfied by Collection.Bidirectional.
    // This extension enables documentation and future default implementations.
}
