# Collection Primitives Insights

<!--
---
title: Swift.Collection Primitives Insights
version: 1.0.0
last_updated: 2026-01-22
applies_to: [swift-collection-primitives]
normative: false
---
-->
Design decisions, implementation patterns, and lessons learned specific to this package.

## Overview

This document captures insights that emerged during development of swift-collection-primitives. These are not API requirements—they are recorded decisions and patterns that inform future work on this package.

**Document type**: Non-normative (recorded decisions, not requirements).

**Consolidation source**: Reflection entries tagged with `[Package: swift-collection-primitives]`.

---

## Protocols Without Element: The ~Copyable Compatibility Design

**Date**: 2026-01-22

**Context**: Discovering that `Collection.Indexed` and `Collection.Bidirectional` work with `~Copyable` elements by deliberately omitting `associatedtype Element` from the protocol.

### The Design Decision

The protocols in this package describe INDEX operations only, without mentioning the element type:

```swift
protocol Indexed: ~Copyable {
    associatedtype Index: Comparable
    var startIndex: Index { get }
    var endIndex: Index { get }
    func index(after i: Index) -> Index
    // NO Element, NO subscript
}
```

Conformers provide subscript access as direct members, not protocol requirements. This enables the `where Element: ~Copyable` constraint—the inverted constraint that adds nothing, merely permitting all elements.

### The Trade-off

What's lost is the unified protocol hierarchy. `Swift.Sequence` and `Swift.Collection` expect `associatedtype Element`. Without it, generic algorithms cannot operate uniformly across conforming types.

What's gained is ~Copyable compatibility today, without waiting for Swift Evolution's suppressed associated types feature.

### Broader Applicability

This pattern—separating index navigation from element access—has general applicability beyond collections. Any protocol design that needs ~Copyable compatibility can use this approach: define the structural operations in the protocol, provide element access as direct members on conformers.

**Applies to**: `Collection.Indexed`, `Collection.Bidirectional`, and any future protocols requiring ~Copyable compatibility.

**Related documentation**:
- `Memory Copyable.md` Workaround 3 (Protocols Without Element)
- `Noncopyable Generics Constraint Propagation.md` Section 5.4 (Experiment 4)

---

## Broken Experiment: collection-foreach-test

**Date**: 2026-02-13

**Context**: The `collection-foreach-test` experiment in `Experiments/` is broken. It uses `typealias Index = Int` and `Array<Element>.Iterator` which doesn't conform to `Sequence.Iterator.Protocol`. Needs update to match current patterns (typed indices, `Sequence.Protocol`-compatible iterators).

**Applies to**: `Experiments/collection-foreach-test/`

---

## Related

- Collection
