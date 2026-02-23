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
/// | `Collection.Slice.Protocol` | Self-slicing via `subscript(Range<Index>) -> Self` |
/// | `Collection.Remove.Last` | Collection supporting `removeLast()` |
///
/// ### Protocol Hierarchy
///
/// ```
/// Sequence.Protocol
///       ↑
/// Collection.Protocol             ← index(after:)
///       ↑                 ↑
/// Collection.Bidirectional  Collection.Slice.Protocol  ← subscript(Range) -> Self
///       ↑
/// Collection.Access.Random        ← O(1) guarantee
/// ```
///
/// ## Inherited from Sequence.Protocol
///
/// These operations are inherited from `Sequence.Protocol` defaults and available
/// on all `Collection.Protocol` conformers automatically:
///
/// | Tag | Operations |
/// |-----|------------|
/// | `Sequence.Contains` | `.contains { }` |
/// | `Sequence.First` | `.first { }` |
/// | `Sequence.Reduce` | `.reduce.into(_:) { }`, `.reduce.from(_:) { }` |
/// | `Sequence.Map` | `.map { }` |
/// | `Sequence.Filter` | `.filter { }` (requires `Element: Copyable`) |
/// | `Sequence.Satisfies` | `.satisfies.all { }`, `.satisfies.any { }`, `.satisfies.none { }` |
/// | `Sequence.Count` | `.count.where { }`, `.count.all` |
/// | `Sequence.Drop` | `.drop.first(_:)`, `.drop.while { }` |
/// | `Sequence.Prefix` | `.prefix.first(_:)`, `.prefix.while { }` |
///
/// ## Collection-Specific Tags
///
/// These operations shadow or extend Sequence defaults with collection-optimized
/// implementations:
///
/// | Tag | Operations |
/// |-----|------------|
/// | `Collection.ForEach` | `.forEach { }`, `.forEach.borrowing { }`, `.forEach.consuming { }` (index-based) |
/// | `Collection.Count` | `.count.where { }`, `.count.all` (returns `Index<Element>.Count`) |
/// | `Collection.Min` | `.min()`, `.min(by:)` |
/// | `Collection.Max` | `.max()`, `.max(by:)` |
/// | `Collection.Remove` | `.remove.last()`, `.remove.all()` |
/// | `Collection.Slice` | `.slice` (future: prefix, suffix, split) |
///
/// ## Types
///
/// | Type | Description |
/// |------|-------------|
/// | `Collection.Rotated` | A rotated view of a collection |
///
/// ## Usage
///
/// Conform your type to `Collection.Protocol`. All inherited Sequence operations
/// and collection-specific `.forEach` and `.count` are available automatically:
///
/// ```swift
/// extension MyContainer: Collection.Protocol {
///     typealias Index = Index_Primitives.Index<Element>
///     var startIndex: Index { .zero }
///     var endIndex: Index { Index(__unchecked: (), position: storage.count) }
///     subscript(position: Index) -> Element { storage[position.position] }
///     func index(after i: Index) -> Index { (i + Index.Offset(1))! }
///     func makeIterator() -> Array<Element>.Iterator { storage.makeIterator() }
/// }
///
/// // All of these work immediately:
/// container.forEach { }       // index-based (Collection.ForEach)
/// container.contains { }      // inherited (Sequence.Contains)
/// container.map { }           // inherited (Sequence.Map)
/// container.count.all         // collection-specific (Collection.Count)
/// ```
public struct Collection: Sendable {}
