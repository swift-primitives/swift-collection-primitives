/// Default partial-range subscripts for `Collection.Slice.Protocol` conformers.
///
/// Uses a two-tier pattern to support both `~Copyable` and `Copyable` conformers:
///
/// - **Tier 1** (`~Copyable`): Yields a borrow via `_read`. Available to all
///   conformers. Callers can read properties and pass to borrowing parameters.
///
/// - **Tier 2** (`Copyable`): Returns an owned value via `get`. Shadows Tier 1
///   for Copyable conformers. Callers receive an independently-owned slice.
///
/// `~Copyable` conformers that need owned partial-range access should implement
/// the subscripts directly on their concrete type (concrete subscript forwarding
/// works — the limitation is in protocol dispatch only).
///
/// This mirrors the two-tier `borrowing` closure pattern used in
/// sequence-primitives for `~Copyable` element support.

// MARK: - Tier 1: ~Copyable (borrowing access via _read)

extension Collection.Slice.`Protocol` where Self: ~Copyable {

    /// Accesses elements from a lower bound to the end (borrowing).
    ///
    /// - Parameter bounds: A partial range from a lower bound.
    /// - Returns: A borrowed sub-range from `bounds.lowerBound` to `endIndex`.
    @inlinable
    public subscript(bounds: PartialRangeFrom<Index>) -> Self {
        _read {
            yield self[bounds.lowerBound..<endIndex]
        }
    }

    /// Accesses elements from the start up to (not including) an upper bound (borrowing).
    ///
    /// - Parameter bounds: A partial range up to an upper bound.
    /// - Returns: A borrowed sub-range from `startIndex` to `bounds.upperBound`.
    @inlinable
    public subscript(bounds: PartialRangeUpTo<Index>) -> Self {
        _read {
            yield self[startIndex..<bounds.upperBound]
        }
    }
}

// MARK: - Tier 2: Copyable (owned access via get)

extension Collection.Slice.`Protocol` {

    /// Accesses elements from a lower bound to the end (owned).
    ///
    /// - Parameter bounds: A partial range from a lower bound.
    /// - Returns: A sub-range from `bounds.lowerBound` to `endIndex`.
    @inlinable
    public subscript(bounds: PartialRangeFrom<Index>) -> Self {
        self[bounds.lowerBound..<endIndex]
    }

    /// Accesses elements from the start up to (not including) an upper bound (owned).
    ///
    /// - Parameter bounds: A partial range up to an upper bound.
    /// - Returns: A sub-range from `startIndex` to `bounds.upperBound`.
    @inlinable
    public subscript(bounds: PartialRangeUpTo<Index>) -> Self {
        self[startIndex..<bounds.upperBound]
    }
}
