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
public struct __CollectionRotated<Base: RandomAccessCollection>: RandomAccessCollection {
    @usableFromInline
    let base: Base

    @usableFromInline
    let _offset: Index_Primitives.Index<Base.Element>.Offset

    @usableFromInline
    let _count: Index_Primitives.Index<Base.Element>.Count

    /// Creates a rotated view of the given collection.
    ///
    /// - Parameters:
    ///   - base: The collection to rotate.
    ///   - startOffset: The number of positions to rotate. The offset is
    ///     normalized modulo the collection count. Negative offsets rotate
    ///     in the opposite direction.
    @inlinable
    public init(base: Base, startOffset: Index_Primitives.Index<Base.Element>.Offset) {
        self.base = base
        let count = base.count
        self._count = Index_Primitives.Index<Base.Element>.Count(_unchecked: Cardinal(UInt(count)))

        if base.isEmpty {
            self._offset = .zero
        } else {
            // Normalize offset to [0, count) handling negative values
            let offsetValue = Int(bitPattern: startOffset)
            let normalizedValue = ((offsetValue % count) + count) % count
            self._offset = Index_Primitives.Index<Base.Element>.Offset(normalizedValue)
        }
    }
}

extension Collection.Rotated {
    /// The position type used to index into the rotated view.
    public typealias Index = Index_Primitives.Index<Base.Element>
}

extension Collection.Rotated {

    /// The position of the first element in the rotated view.
    @inlinable
    public var startIndex: Index { .zero }

    /// The position one past the last element in the rotated view.
    @inlinable
    public var endIndex: Index { _count.map(Ordinal.init) }

    /// Returns the index after the given index.
    @inlinable
    public func index(after i: Index) -> Index {
        i.successor.saturating()
    }

    /// Returns the index before the given index.
    @inlinable
    public func index(before i: Index) -> Index {
        do throws(Ordinal.Error) {
            return try i.predecessor.exact()
        } catch {
            return .zero
        }
    }

    /// Returns the index offset from the given index by the given distance.
    @inlinable
    // swift-linter:disable:next int public parameter
    // REASON: `Swift.BidirectionalCollection.index(_:offsetBy:)` and
    //   `Swift.Collection.index(_:offsetBy:)` are protocol-witness signatures
    //   dictated by the stdlib — the conformer cannot change the `Int`
    //   parameter type. See [RULE-EXEMPT-2] protocol-witness-citation-dict
    //   family; mirrors the cyclic-primitives `+Literals.swift` precedent.
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        do throws(Ordinal.Error) {
            return try i + Index.Offset(distance)
        } catch {
            return self.endIndex
        }
    }

    /// Returns the distance between two indices.
    @inlinable
    // swift-linter:disable:next int public parameter
    // REASON: `Swift.Collection.distance(from:to:)` is a protocol-witness
    //   signature dictated by the stdlib — the conformer cannot change the
    //   `Int` return type. See [RULE-EXEMPT-2] protocol-witness-citation-dict
    //   family; mirrors the cyclic-primitives `+Literals.swift` precedent.
    public func distance(from start: Index, to end: Index) -> Int {
        do throws(Affine.Discrete.Vector.Error) {
            return Int(bitPattern: try end - start as Affine.Discrete.Vector)
        } catch {
            return .zero
        }
    }

    /// Accesses the element at the specified position in the rotated view.
    @inlinable
    public subscript(position: Index) -> Base.Element {
        // Affine arithmetic: point + vector → point, then modular wrap
        let physicalIndex: Index
        do throws(Ordinal.Error) {
            physicalIndex = try (position + _offset) % _count
        } catch {
            physicalIndex = .zero
        }
        return base[base.index(base.startIndex, offsetBy: Int(bitPattern: physicalIndex.position))]
    }
}

// MARK: - Sendable

extension Collection.Rotated: Sendable where Base: Sendable {}

// MARK: - Collection.Rotated typealias

extension Collection {
    /// A rotated view of a collection.
    ///
    /// Typealias for ``__CollectionRotated``. See that type for full documentation.
    public typealias Rotated<Base: RandomAccessCollection> = __CollectionRotated<Base>
}
