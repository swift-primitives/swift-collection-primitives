// Collection.Rotated.swift
// A rotated view of a collection.

/// Hoisted type for `Collection.Rotated`.
///
/// A collection that presents a rotated view of another collection.
/// `Rotated` shifts the logical starting position of a collection while
/// maintaining the same elements. This is a zero-copy view that computes
/// indices on access.
///
/// ## Example
///
/// ```swift
/// let original = ["a", "b", "c", "d"]
/// let rotated = Collection.Rotated(base: original, startOffset: 1)
/// print(Array(rotated)) // ["b", "c", "d", "a"]
/// ```
///
/// ## Use Cases
///
/// - Efficient `tail` operations on cyclic structures
/// - Ring buffer access patterns
/// - Circular iteration without copying
///
/// - Note: This type is hoisted to module level with `__` prefix because Swift
///   doesn't allow types nested in protocols. The canonical name is
///   `Collection.Rotated` (via typealias).
public struct __CollectionRotated<Base: RandomAccessCollection & Sendable>: RandomAccessCollection, Sendable
where Base.Element: Sendable {
    @usableFromInline
    let base: Base

    @usableFromInline
    let startOffset: Int

    /// Creates a rotated view of the given collection.
    ///
    /// - Parameters:
    ///   - base: The collection to rotate.
    ///   - startOffset: The number of positions to rotate. The offset is
    ///     normalized modulo the collection count.
    @inlinable
    public init(base: Base, startOffset: Int) {
        self.base = base
        self.startOffset = base.isEmpty ? 0 : startOffset % base.count
    }

    @inlinable
    public var startIndex: Int { 0 }

    @inlinable
    public var endIndex: Int { base.count }

    @inlinable
    public subscript(position: Int) -> Base.Element {
        let actualIndex = (startOffset + position) % base.count
        return base[base.index(base.startIndex, offsetBy: actualIndex)]
    }

    @inlinable
    public func index(after i: Int) -> Int { i + 1 }

    @inlinable
    public func index(before i: Int) -> Int { i - 1 }

    @inlinable
    public func index(_ i: Int, offsetBy distance: Int) -> Int { i + distance }

    @inlinable
    public func distance(from start: Int, to end: Int) -> Int { end - start }
}

// MARK: - Collection.Rotated typealias

extension Collection {
    /// A rotated view of a collection.
    ///
    /// Typealias for ``__CollectionRotated``. See that type for full documentation.
    public typealias Rotated<Base: RandomAccessCollection & Sendable> = __CollectionRotated<Base>
        where Base.Element: Sendable
}
