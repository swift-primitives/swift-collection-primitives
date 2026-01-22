/// Namespace for collection-related protocols and types.
///
/// `Collection` provides a namespace for protocols and types that support
/// indexed, multi-pass iteration over elements. Unlike stdlib's `Collection`
/// protocol, these protocols support `~Copyable` conformers.
///
/// ## Protocols
///
/// | Protocol | Description |
/// |----------|-------------|
/// | `Collection.Protocol` | Indexed, multi-pass iteration (extends `Sequence.Protocol`) |
/// | `Collection.Bidirectional` | Backward traversal via `index(before:)` |
/// | `Collection.Access.Random` | O(1) index arithmetic guarantee |
/// | `Collection.Clearable` | Collection that can be cleared for consuming iteration |
///
/// ### Protocol Hierarchy
///
/// ```
/// Sequence.Protocol
///       ↑
/// Collection.Protocol        ← index(after:)
///       ↑
/// Collection.Bidirectional   ← index(before:)
///       ↑
/// Collection.Access.Random   ← O(1) guarantee
/// ```
///
/// ## Tags
///
/// | Tag | Operations |
/// |-----|------------|
/// | `Collection.ForEach` | `.forEach { }`, `.forEach.borrowing { }`, `.forEach.consuming { }` |
/// | `Collection.Satisfies` | `.satisfies.all { }`, `.satisfies.any { }`, `.satisfies.none { }` |
/// | `Collection.Contains` | `.contains { }` |
/// | `Collection.First` | `.first { }` |
/// | `Collection.Reduce` | `.reduce.into(_:) { }`, `.reduce.from(_:) { }` |
/// | `Collection.Map` | `.map { }` |
/// | `Collection.Filter` | `.filter { }` (requires `Element: Copyable`) |
/// | `Collection.Count` | `.count.where { }`, `.count.all` |
///
/// ## Types
///
/// | Type | Description |
/// |------|-------------|
/// | `Collection.Rotated` | A rotated view of a collection |
///
/// ## Usage
///
/// 1. Conform your type to `Collection.Protocol`:
///
/// ```swift
/// extension MyContainer: Collection.Protocol {
///     typealias Index = Int
///     var startIndex: Int { 0 }
///     var endIndex: Int { storage.count }
///     subscript(position: Int) -> Element { storage[position] }
///     func index(after i: Int) -> Int { i + 1 }
///     func makeIterator() -> Array<Element>.Iterator { storage.makeIterator() }
/// }
/// ```
///
/// 2. Add property accessors for desired operations:
///
/// ```swift
/// extension MyContainer {
///     var forEach: Property<Collection.ForEach, MyContainer>.View {
///         mutating _read {
///             yield unsafe Property<Collection.ForEach, MyContainer>.View(&self)
///         }
///     }
///     // ... other operations as needed
/// }
/// ```
public struct Collection: Sendable {}
