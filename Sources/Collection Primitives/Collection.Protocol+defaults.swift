/// Default implementations for `Collection.Protocol` conformers.
///
/// Provides `isEmpty` and `formIndex(after:)` as extension defaults,
/// mirroring the defaults on `Collection.Indexed`.
extension Collection.`Protocol` where Self: ~Copyable {
    /// A Boolean value indicating whether the collection is empty.
    @inlinable
    public var isEmpty: Bool { startIndex == endIndex }

    /// Updates the given index to its successor.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than `endIndex`.
    @inlinable
    public func formIndex(after i: inout Index) {
        i = index(after: i)
    }
}
