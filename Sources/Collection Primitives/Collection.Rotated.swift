// Collection.Rotated.swift
// A rotated view of a collection.

public import Index_Primitives

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
    public typealias Index = Index_Primitives.Index<Base.Element>

    @usableFromInline
    let base: Base

    @usableFromInline
    let normalizedOffset: Index.Offset

    @usableFromInline
    let _count: Index.Count

    /// Creates a rotated view of the given collection.
    ///
    /// - Parameters:
    ///   - base: The collection to rotate.
    ///   - startOffset: The number of positions to rotate. The offset is
    ///     normalized modulo the collection count.
    @inlinable
    public init(base: Base, startOffset: Int) {
        self.base = base
        let count = base.count
        self.normalizedOffset = base.isEmpty ? Index.Offset(0) : Index.Offset(startOffset % count)
        self._count = Index.Count(__unchecked: count)
    }

    @inlinable
    public var startIndex: Index { .zero }

    @inlinable
    public var endIndex: Index {
        Index(__unchecked: (), position: _count.rawValue)
    }

    @inlinable
    public subscript(position: Index) -> Base.Element {
        let actualIndex = (normalizedOffset.rawValue + position.position.rawValue) % _count.rawValue
        return base[base.index(base.startIndex, offsetBy: actualIndex)]
    }

    @inlinable
    public func index(after i: Index) -> Index {
        (i + Index.Offset(1))!
    }

    @inlinable
    public func index(before i: Index) -> Index {
        (i - Index.Offset(1))!
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        (i + Index.Offset(distance))!
    }

    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        (end - start).rawValue
    }
}

// MARK: - Collection.Rotated typealias

extension Collection {
    /// A rotated view of a collection.
    ///
    /// Typealias for ``__CollectionRotated``. See that type for full documentation.
    public typealias Rotated<Base: RandomAccessCollection & Sendable> = __CollectionRotated<Base>
        where Base.Element: Sendable
}
