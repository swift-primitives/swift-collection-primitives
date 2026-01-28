//
//  Collection.Protocol+Index.swift
//  swift-collection-primitives
//
//  Default implementations for index distance and offset operations.
//

import Range_Primitives

extension Collection.`Protocol` where Self: ~Copyable {
    /// Returns the distance between two indices.
    ///
    /// - Parameters:
    ///   - start: A valid index of the collection.
    ///   - end: Another valid index of the collection.
    /// - Returns: The number of steps from `start` to `end`.
    /// - Complexity: O(*n*), where *n* is the resulting distance.
    @inlinable
    public func distance(from start: Index, to end: Index) -> Int {
        var count = 0
        var index = start
        while index < end {
            index = self.index(after: index)
            count += 1
        }
        return count
    }

    /// Returns an index that is the specified distance from the given index.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - distance: The distance to offset `i`.
    /// - Returns: An index offset by `distance` from `i`.
    /// - Precondition: `distance >= 0` and the resulting index must be valid.
    /// - Complexity: O(*n*), where *n* is `distance`.
    @inlinable
    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        var index = i
        for _ in 0..<distance {
            index = self.index(after: index)
        }
        return index
    }

    /// Returns an index that is the specified typed offset from the given index.
    ///
    /// This overload accepts a typed `Index<T>.Offset` for type-safe index arithmetic.
    ///
    /// - Parameters:
    ///   - i: A valid index of the collection.
    ///   - offset: The typed offset to apply.
    /// - Returns: An index offset by `offset` from `i`.
    /// - Precondition: The resulting index must be valid.
    /// - Complexity: O(*n*), where *n* is the magnitude of `offset`.
    @inlinable
    public func index<T: ~Copyable>(
        _ i: Index,
        offsetBy offset: Index_Primitives.Index<T>.Offset
    ) -> Index {
        index(i, offsetBy: offset.vector.rawValue)
    }
}
