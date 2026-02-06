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
    ///     normalized modulo the collection count. Negative offsets rotate
    ///     in the opposite direction.
    @inlinable
    public init(base: Base, startOffset: Index.Offset) {
        self.base = base
        let count = base.count
        self._count = Index.Count(__unchecked: (), Cardinal(UInt(count)))

        if base.isEmpty {
            self.normalizedOffset = .zero
        } else {
            // Normalize offset to [0, count) handling negative values
            let offsetValue = startOffset.vector.rawValue
            let normalizedValue = ((offsetValue % count) + count) % count
            self.normalizedOffset = Index.Offset(normalizedValue)
        }
    }
}

extension Collection.Rotated {
    
    @inlinable
    public var startIndex: Index { .zero }

    @inlinable
    public var endIndex: Index { Index(__unchecked: (), Ordinal(_count.rawValue)) }
    
    @inlinable
    public func index(after i: Index) -> Index {
        i + .one
    }

    @inlinable
    public func index(before i: Index) -> Index {
        do {
            return try i - Index.Offset.one
        } catch {
            return .zero
        }
    }

    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        do {
            return try i + Index.Offset(distance)
        } catch {
            return self.endIndex
        }
    }

    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        (try! (end - start)).vector.rawValue
    }
    
    @inlinable
    public subscript(position: Index) -> Base.Element {
        // Affine arithmetic: point + vector → point, then modular wrap
        let physicalIndex = (try! position + normalizedOffset) % _count
        return base[base.index(base.startIndex, offsetBy: Int(bitPattern: physicalIndex.position))]
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
