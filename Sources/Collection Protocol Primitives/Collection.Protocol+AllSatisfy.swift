//
//  Collection.Protocol+AllSatisfy.swift
//  swift-collection-primitives
//
//  Universal-quantifier over a collection's elements.
//

extension Collection.`Protocol` where Self: ~Copyable, Element: Copyable {
    /// Returns whether every element satisfies `predicate`.
    ///
    /// Index-based traversal over the collection's own `Element` (the element
    /// the collection is parameterized on — distinct from `Iterable`'s
    /// `Iterator.Element`), so it composes directly with `Element`-constrained
    /// generic code. Vacuously `true` for an empty collection; stops at the first
    /// failure. Mirrors `Swift.Collection.allSatisfy(_:)`.
    @inlinable
    public func allSatisfy<E: Swift.Error>(
        _ predicate: (Element) throws(E) -> Bool
    ) throws(E) -> Bool {
        var i = startIndex
        while i < endIndex {
            if try !predicate(self[i]) { return false }
            i = index(after: i)
        }
        return true
    }
}
