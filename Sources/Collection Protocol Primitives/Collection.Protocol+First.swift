//
//  Collection.Protocol+First.swift
//  swift-collection-primitives
//
//  First-element accessor on the collection protocol.
//

extension Collection.`Protocol` where Self: ~Copyable, Element: Copyable {
    /// The first element of the collection, or `nil` if it is empty.
    ///
    /// A within-scope read: it returns the *element*, not its index, so it is
    /// available for any admitted `Index` (no `Escapable` requirement). Requires
    /// `Element: Copyable` to return the element by value. Mirrors
    /// `Swift.Collection.first`.
    @inlinable
    public var first: Element? {
        isEmpty ? nil : self[startIndex]
    }
}
