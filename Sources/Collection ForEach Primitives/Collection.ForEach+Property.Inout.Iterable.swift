public import Iterable
public import Property_Primitives

/// `Property.Inout` extensions providing `.forEach` operations for `Collection.Protocol`
/// conformers whose `Index` is `~Escapable`, routed through `Iterable`.
///
/// The companion `Collection.ForEach+Property.Inout.swift` provides index-based
/// defaults gated on `Base.Index: Escapable`. A conformer whose `Index` is
/// `~Escapable` (the `Collection.Protocol.Index` KEEP decision) matches neither of
/// those, so it gets the `.forEach` accessor but no operations. This extension fills
/// that gap by routing iteration through `Iterable` rather than an index loop — no
/// index ever escapes the iteration.
///
/// Only the **element-yielding** operations are provided here. The index-yielding
/// `.index { }` operation is intentionally absent: a `~Escapable` index cannot be
/// handed out past the iteration, so external index iteration is offered only on the
/// `Base.Index: Escapable` path.
///
/// ## Delegation to `Iterable.forEach`, not a hand-rolled iterator loop
///
/// These operations delegate to `Iterable`'s own `forEach` terminal
/// (`base.value.forEach { ... }`) rather than calling `makeIterator()` and driving the
/// iterator across a `while` loop. The latter does not typecheck on the production
/// compiler: `Property.Inout`'s `base.value` is yielded by a `_read` coroutine
/// (statement-scoped), and `makeIterator()` is `@_lifetime(borrow self)`, so an
/// iterator bound in this method "escapes its scope" — the exact constraint documented
/// by `swift-iterator-primitives`' `Iterable+ForEach.swift` and its `Canary` test.
/// Delegating keeps the iterator's lifetime fully inside `Iterable.forEach`, scoped to
/// the borrow we hand it, which is borrow-correct today.
///
/// ## Disambiguation
///
/// `Base: Iterable` (with no index requirement) also matches a conformer that is
/// `Base.Index: Escapable` **and** `Iterable`, overlapping with the index-based
/// defaults. The operations here carry `@_disfavoredOverload` so that, when both apply,
/// overload resolution selects the index-based default; only `~Escapable`-index
/// conformers (which match no index-based overload) resolve to these.
extension Property.Inout
where Base: Collection.`Protocol` & Iterable & ~Copyable,
      Base.Iterator.Element == Base.Element,
      Base.Iterator.Failure == Never,
      Tag == Collection.ForEach {

    /// Borrowing iteration via `.forEach { }`, routed through `Iterable`.
    ///
    /// Iterates over all elements without consuming the collection. Each element is
    /// handed to `body` by borrow. Provided for `~Escapable`-index conformers, which
    /// cannot use the index-based default.
    ///
    /// - Parameter body: A closure called with each element.
    @_disfavoredOverload
    @inlinable
    public func callAsFunction(_ body: (borrowing Base.Element) -> Void) {
        base.value.forEach { body($0) }
    }

    /// Explicit borrowing iteration via `.forEach.borrowing { }`, routed through `Iterable`.
    ///
    /// Same as `callAsFunction`, but with explicit naming for clarity.
    ///
    /// - Parameter body: A closure called with each element.
    @_disfavoredOverload
    @inlinable
    public func borrowing(_ body: (borrowing Base.Element) -> Void) {
        base.value.forEach { body($0) }
    }
}

/// `Property.Inout` extension providing consuming `.forEach` iteration for
/// `Collection.Clearable` conformers whose `Index` is `~Escapable`, routed through
/// `Iterable`.
extension Property.Inout
where Base: Collection.Clearable & Iterable & ~Copyable,
      Base.Iterator.Element == Base.Element,
      Base.Iterator.Failure == Never,
      Tag == Collection.ForEach {

    /// Consuming iteration via `.forEach.consuming { }`, routed through `Iterable`.
    ///
    /// Iterates over all elements and then clears the collection — mirroring the
    /// end-state of the index-based consuming default.
    ///
    /// - Parameter body: A closure called with each element.
    @_disfavoredOverload
    @inlinable
    public mutating func consuming(_ body: (borrowing Base.Element) -> Void) {
        base.value.forEach { body($0) }
        unsafe Base.removeAll(&base.value)
    }
}
