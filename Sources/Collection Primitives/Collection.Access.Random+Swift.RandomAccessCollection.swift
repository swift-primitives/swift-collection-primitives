/// Bridge to `Swift.RandomAccessCollection` for `Copyable` conformers.
///
/// Types conforming to `Collection.Access.Random` that are `Copyable` can also
/// conform to `Swift.RandomAccessCollection` with no additional implementation:
///
/// ```swift
/// struct MyContainer: Collection.Access.Random, Swift.RandomAccessCollection {
///     // Collection.Access.Random requirements satisfy Swift.RandomAccessCollection
/// }
/// ```
///
/// ## Why This Works
///
/// Both `Collection.Access.Random` and `Swift.RandomAccessCollection` are
/// semantic protocols that add no new requirements beyond their parent
/// (`Collection.Bidirectional` and `Swift.BidirectionalCollection` respectively).
/// They declare the O(1) index arithmetic guarantee.
///
/// ## Usage
///
/// ```swift
/// // 1. Define your type with Collection.Access.Random
/// struct Numbers: Collection.Access.Random {
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
/// // 2. Add Swift.RandomAccessCollection conformance
/// extension Numbers: Swift.RandomAccessCollection {}
///
/// // 3. Gets O(1) count, efficient slicing, and all stdlib algorithms
/// let count = numbers.count  // O(1)
/// let middle = numbers[numbers.count / 2]  // O(1) access
/// ```
extension Collection.Access.Random where Self: Copyable {
    // All requirements satisfied by Collection.Access.Random.
    // This extension enables documentation and future default implementations.
}
