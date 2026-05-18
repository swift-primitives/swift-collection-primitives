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
/// | `Collection.Protocol` | Indexed, multi-pass iteration (standalone) |
/// | `Collection.Bidirectional` | Backward traversal via `index(before:)` |
/// | `Collection.Access.Random` | O(1) index arithmetic guarantee |
/// | `Collection.Clearable` | Collection that can be cleared for consuming iteration |
/// | `Collection.Slice.Protocol` | Self-slicing via `subscript(Range<Index>) -> Self` |
/// | `Collection.Remove.Last` | Collection supporting `.remove.last()` |
///
/// ### Protocol Hierarchy
///
/// ```
/// Collection.Indexed                    ← startIndex, endIndex, index(after:)
///       ↑
/// Collection.Bidirectional              ← index(before:)
///       ↑
/// Collection.Access.Random              ← O(1) guarantee
///
/// Collection.Protocol                   ← Element, subscript (standalone)
/// ```
///
/// `Collection.Protocol` and `Collection.Indexed` are parallel hierarchies.
/// Types typically conform to both. `Sequence.Protocol` is a separate protocol
/// for iterator-based access — types wanting `for-in` conform to it separately.
///
/// ## Collection-Specific Tags
///
/// These operations are provided automatically on `Collection.Protocol` conformers:
///
/// | Tag | Operations |
/// |-----|------------|
/// | `Collection.ForEach` | `.forEach { }`, `.forEach.borrowing { }`, `.forEach.consuming { }` (index-based) |
/// | `Collection.Count` | `.count.where { }`, `.count.all` (returns `Index<Element>.Count`) |
/// | `Collection.Min` | `.min()`, `.min(by:)`, `.min.index(by:)` |
/// | `Collection.Max` | `.max()`, `.max(by:)`, `.max.index(by:)` |
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
/// Conform your type to `Collection.Protocol`. All collection-specific `.forEach`,
/// `.count`, `.min`, and `.max` are available automatically:
///
/// ```swift
/// extension MyContainer: Collection.Protocol {
///     var startIndex: Index { .zero }
///     var endIndex: Index { Index(_unchecked: position: storage.count) }
///     subscript(position: Index) -> Element { storage[Int(bitPattern: position)] }
///     func index(after i: Index) -> Index { (i + Index.Offset(1))! }
/// }
///
/// // All of these work immediately:
/// container.forEach { }       // index-based (Collection.ForEach)
/// container.count.all         // collection-specific (Collection.Count)
/// container.min(by: .ascending) // index-based (Collection.Min)
/// ```
public struct Collection: Sendable {}
