// Collection.ForEach Tests.swift
//
// `Collection.Protocol` refines `Iterable`, so every collection conformer inherits
// the multipass iteration terminal `Iterable.forEach`. The dedicated
// `Collection.ForEach` Property apparatus (and its index-based vs Iterable-routed
// disambiguation) has been removed: there is now a single `forEach` surface, the
// inherited one. These tests pin that the inherited `forEach`:
//   • visits every element in index order;
//   • is non-destructive (borrowing / multipass — callable repeatedly);
// resolved through the `Collection.Protocol: Iterable` refinement.

import Collection_Primitives_Test_Support
import Index_Primitives
import Iterable
import Testing

@testable import Collection_Primitives

// MARK: - Suite

extension Collection {
    @Suite
    struct `ForEach Test` {
        @Suite struct Inherited {}
    }
}

extension Collection.`ForEach Test`.Inherited {

    @Test
    func `inherited forEach visits every element in order`() {
        let source = Collection.Fixture.Source([1, 2, 3])

        var collected: [Int] = []
        source.forEach { collected.append($0) }

        #expect(collected == [1, 2, 3])
    }

    @Test
    func `inherited forEach is non-destructive (multipass)`() {
        let source = Collection.Fixture.Source([1, 2])

        var first: [Int] = []
        source.forEach { first.append($0) }
        var second: [Int] = []
        source.forEach { second.append($0) }

        #expect(first == [1, 2])
        #expect(second == [1, 2])
    }

    @Test
    func `inherited forEach over an empty collection visits nothing`() {
        let source = Collection.Fixture.Source<Int>([])

        var collected: [Int] = []
        source.forEach { collected.append($0) }

        #expect(collected.isEmpty)
    }

    @Test
    func `inherited forEach is available on a Clearable conformer`() {
        let source = Collection.Fixture.Clearable.Source([7, 8, 9])

        var collected: [Int] = []
        source.forEach { collected.append($0) }

        #expect(collected == [7, 8, 9])
    }
}
