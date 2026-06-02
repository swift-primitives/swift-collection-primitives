# Collection Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Indexed-collection protocol family for Swift — `Collection.Protocol` with `~Copyable` element support, a single `Collection.Protocol` → `Bidirectional` → `Access.Random` traversal hierarchy, and automatic fluent terminal operations (`.forEach`, `.count`, `.min`, `.max`, `.remove`, `.slice`) provided by protocol extension.

Stdlib's `Swift.Collection` requires `Element: Copyable` (per SE-0427): its `subscript(position) -> Element { get }` accessor returns an owned value, which closes the protocol off to `~Copyable` conformers and `~Copyable` elements. `Collection.Protocol` in this package declares `associatedtype Element: ~Copyable` and a `subscript(position) -> Element { get }` that conformers satisfy with a `_read` (borrowing) accessor — the element is yielded in place, never moved out — so move-only containers and containers of move-only elements reach the same index-navigation and terminal-operation surface as `Copyable` ones.

This package is part of **Story 2 of the data-structures cohort** (`data-structures-launch-2026`): seven packages introducing typed indexing and sequences — order, index, sequence, **collection**, input, cyclic, vector. Story 1 (cardinal, ordinal, affine) shipped 2026-05-12; Story 2 Wave 1 (order + index) shipped 2026-05-13; Wave 2 (sequence) shipped 2026-05-16; Wave 3 (cyclic) shipped 2026-05-18. Collection depends on comparison (for index ordering), index (for `Index<Element>` and `Index.Offset`), order (for `Order.Comparator`), property (for the fluent `.<op>` accessors), and iterator (for the `Iterable` protocol family).

---

## Quick Start

```swift
import Collection_Primitives

// Conform a container to Collection.Protocol — startIndex, endIndex,
// subscript, index(after:) are the four primitives.
struct Numbers: Collection.`Protocol` {
    var storage: [Int]

    var startIndex: Index { .zero }
    var endIndex: Index { Index(_unchecked: position: storage.count) }
    subscript(position: Index) -> Int { storage[Int(bitPattern: position.position)] }
    func index(after i: Index) -> Index { (i + Index.Offset(1))! }
}

var numbers = Numbers(storage: [3, 1, 4, 1, 5, 9, 2, 6])

// Terminal ops via the fluent `.<op>` Property.Inout accessors —
// all provided automatically by protocol extension.
let total      = numbers.count.all                           // Index<Int>.Count(8)
let evenCount  = numbers.count.where { $0 % 2 == 0 }         // Index<Int>.Count(3)
let smallest   = numbers.min()                               // Optional(1)
let largestIdx = numbers.max.index(by: .ascending)           // Optional(position of 9)

// forEach takes the closure directly; .forEach.borrowing { } is the
// explicit-ownership variant.
numbers.forEach { element in
    print(element)
}
```

For `~Copyable` element types — file descriptors, unique resource handles, `Span<T>` — conform to `Collection.Protocol` with `associatedtype Element: ~Copyable`. The terminal operations that return indices (`.count.where`, `.min.index(by:)`, `.max.index(by:)`) work without copies; the value-returning variants (`.min()`, `.max()`) require `Element: Copyable` and silently disappear from the surface for `~Copyable` elements.

---

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-collection-primitives.git", branch: "main"),
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Collection Primitives", package: "swift-collection-primitives"),
    ]
)
```

The package is pre-1.0 — until 0.1.0 is tagged, depend on `branch: "main"` rather than `from: "0.1.0"`. Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products: the umbrella source target and a Test Support spine.

| Product | When to import | What's in it |
|---------|---------------|--------------|
| `Collection Primitives` | Default for application code | The protocol family (`Collection.Protocol`, `Collection.Bidirectional`, `Collection.Access.Random`, `Collection.Clearable`, `Collection.Remove.Last`, `Collection.Slice.Protocol`), the automatic fluent surface (`.forEach`, `.count`, `.min`, `.max`, `.remove`, `.slice`), the `Collection.Rotated` view, and stdlib bridges to `Swift.Collection` / `Swift.RandomAccessCollection` for `Copyable` conformers. The package re-exports its external dependencies (`Comparison_Primitives`, `Index_Primitives`, `Order_Primitives`, `Property_Primitives`, and `Iterable`) so a single `import Collection_Primitives` brings the full surface into scope. |
| `Collection Primitives Test Support` | Test targets | Fixtures and re-exports for downstream test consumers. Re-exports the umbrella plus `Index Primitives Test Support`. |

Foundation-free. No concurrency surface. No platform conditionals.

### A single index hierarchy

`Collection.Protocol` is the single root of the index hierarchy. `Collection.Bidirectional` refines it (adding `index(before:)`), and `Collection.Access.Random` refines `Collection.Bidirectional` (adding the O(1)-index-arithmetic guarantee):

```
Collection.Protocol      ← Element, Index, startIndex, endIndex, subscript, index(after:)
      ↑
Collection.Bidirectional ← index(before:)
      ↑
Collection.Access.Random ← O(1) guarantee
```

`~Copyable` element support comes from `Collection.Protocol` itself: it declares `associatedtype Element: ~Copyable`, and its `subscript(position:) -> Element { get }` is satisfied by a `_read` (borrowing) accessor that yields the element in place rather than moving it out. So the `Bidirectional` and `Access.Random` refinements work for containers of move-only elements without any separate navigation root. (An earlier design carried a separate bare-index-navigation protocol — no `Element`, no `subscript` — to dodge a presumed `Copyable` gate on `subscript { get }`; it proved redundant, because the `_read` subscript already avoids that gate, and was removed.)

`Collection.Protocol` refines `Iterable` (the multi-pass / borrow attachable), so every conformer vends a span-based `makeIterator()` and inherits the `Iterable` terminals (`.forEach`, `.reduce`, `.contains`, `.first`) for free. It does **not** refine `Sequenceable` (the single-pass / consuming attachable) — that is an orthogonal capability. Bridging to `Swift.Collection` or `for-in` additionally needs a `Swift.Sequence`-compatible `makeIterator()`, since the `Iterable` witness is a borrowing *chunk* iterator rather than a scalar `Swift.IteratorProtocol`.

### Terminal operations as protocol extensions

The fluent surface — `.forEach`, `.count`, `.min`, `.max`, `.remove`, `.slice` — is provided automatically by protocol extension on `Collection.Protocol`. Conformers do not implement these accessors; satisfying the four primitive requirements (`startIndex`, `endIndex`, `subscript`, `index(after:)`) is sufficient. The accessors compose with the phantom-tagged `Property<Tag, Base>.Inout` machinery from `swift-property-primitives`, so terminal ops like `.min(by:)` and `.min.index(by:)` discover themselves at the call site without separate conformance work.

`.remove.last()` requires `Collection.Remove.Last` conformance; `.remove.all()` and `.forEach.consuming { }` require `Collection.Clearable` conformance. Both are opt-in capabilities — the static `removeLast(_:)` / `removeAll(_:)` primitives let containers expose mutation only when the underlying storage supports it.

---

## `~Copyable` element support

`Collection.Protocol` declares `associatedtype Element: ~Copyable`, and its `subscript(position:) -> Element { get }` is satisfied by a `_read` (borrowing) accessor, so index navigation and element access work for containers of move-only types without forfeiting the index hierarchy — the `Bidirectional` and `Access.Random` refinements inherit that support directly. Element-returning terminal operations (`.min()`, `.max()` value forms) silently constrain to `Element: Copyable`; index-returning operations (`.min.index(by:)`, `.max.index(by:)`, `.count.where`) work over `~Copyable` elements. This lets a container of file descriptors reach the same index-finding surface as a container of integers, without compromising either case.

For self-slicing containers, `Collection.Slice.Protocol` adds `subscript(bounds: Range<Index>) -> Self`. The package provides partial-range subscripts (`self[i...]`, `self[..<i]`) as defaults via a two-tier pattern: a `~Copyable`-safe borrowing tier via `_read`, and a `Copyable` tier that returns owned values via `get`.

---

## `Collection.Rotated`

`Collection.Rotated<Base>` is a zero-copy rotated view over a `Swift.RandomAccessCollection`. The rotation offset is normalized modulo the base count (negative offsets rotate in the opposite direction); indices are computed on access via affine arithmetic plus a modular wrap. The view itself conforms to `Swift.RandomAccessCollection`, so consumers can use it anywhere a stdlib random-access collection is accepted.

```swift
let original = ["a", "b", "c", "d"]
let rotated = Collection.Rotated(base: original, startOffset: 1)
print(Array(rotated))  // ["b", "c", "d", "a"]
```

The type is hoisted to module level as `__CollectionRotated` and re-exported as `Collection.Rotated` via typealias — Swift does not currently permit nested types inside protocols, and the typealias keeps the namespaced call-site form intact.

---

## Platform Support

| Platform | CI | Status |
|----------|-----|--------|
| macOS 26 | Yes | Full support |
| iOS / tvOS / watchOS / visionOS | — | Supported |
| Linux | Yes | Full support |
| Windows | Yes | Full support |
| Swift Embedded | — | Possible (no Foundation, no concurrency surface; first-party Embedded matrix runs post-flip) |

---

## Stability

Pre-1.0. The public API of `Collection.Protocol` and its members may change while the package remains on `branch: "main"`; consumers should expect breaking changes to surface in commit messages until the first tag. Once tagged, the package follows institute SemVer: post-1.0 breaking changes ship behind a major bump.

| Surface | 0.1.x expectation |
|---|---|
| Public type names (`Collection.Protocol`, `Collection.Bidirectional`, `Collection.Access.Random`, `Collection.Slice.Protocol`, `Collection.Rotated`) | Stable within 0.1.x |
| Documented initializers, accessors, and the fluent `.<op>` surface | Stable within 0.1.x |
| Internal storage shapes and the hoisted `__CollectionRotated` backing | Not part of the source-stability commitment |

The single index hierarchy (`Collection.Protocol` → `Collection.Bidirectional` → `Collection.Access.Random`, described in [A single index hierarchy](#a-single-index-hierarchy)) is the 0.1.0 shape. An earlier design split bare index navigation into a separate parallel protocol; that split proved redundant — `Collection.Protocol`'s `_read` subscript already carries `~Copyable` support — and was removed.

---

## Related Packages

Direct dependencies (all already-public):

- [swift-comparison-primitives](https://github.com/swift-primitives/swift-comparison-primitives) — `Comparison.Protocol`, the `Comparable`-shape conformance the `Collection.Protocol` `Index` associated type requires.
- [swift-index-primitives](https://github.com/swift-primitives/swift-index-primitives) — `Index<Element>`, `Index.Offset`, and `Index.Count`, the typed-indexing surface the protocol family is built on.
- [swift-order-primitives](https://github.com/swift-primitives/swift-order-primitives) — `Order.Comparator`, the comparator type `.min(by:)`, `.max(by:)`, and the index-returning variants consume.
- [swift-property-primitives](https://github.com/swift-primitives/swift-property-primitives) — `Property<Tag, Base>.Inout`, the phantom-tagged fluent-accessor machinery that powers `.forEach { }`, `.count.where { }`, `.min(by:)`, `.max.index(by:)`, and the rest of the terminal surface.
Cohort siblings (Story 2 — Typed indexing and sequences):

- order, index, sequence, **collection**, input, cyclic, vector — see [`data-structures-launch-2026`](https://github.com/swift-institute) for the cohort narrative.

Story 1 sibling primitives ([`cardinal`](https://github.com/swift-primitives/swift-cardinal-primitives), [`ordinal`](https://github.com/swift-primitives/swift-ordinal-primitives), [`affine`](https://github.com/swift-primitives/swift-affine-primitives)) shipped 2026-05-12 and supply the counting / position / displacement primitives the index hierarchy is built on.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public flip.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
