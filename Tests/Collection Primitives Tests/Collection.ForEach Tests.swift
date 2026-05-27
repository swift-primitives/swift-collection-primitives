// Collection.ForEach Tests.swift
//
// Disambiguation coverage for the two `.forEach` operation surfaces:
//   • the index-based default (Collection.ForEach+Property.Inout.swift), gated
//     `Base.Index: Escapable`;
//   • the Iterable-routed default (Collection.ForEach+Property.Inout.Iterable.swift),
//     gated `Base: Iterable` and marked `@_disfavoredOverload`.
//
// The risk these tests pin down: a conformer that is BOTH `Base.Index: Escapable`
// AND `Iterable` matches both gates. `@_disfavoredOverload` on the Iterable surface
// must make the index-based default win, with no "ambiguous use" error.

import Collection_Primitives_Test_Support
import Index_Primitives
import Iterable
import Testing

@testable import Collection_Primitives

// MARK: - Instrumented dual-conformer fixture

extension Collection.Fixture {
    /// Namespace for `.forEach` disambiguation fixtures.
    enum ForEach {}
}

extension Collection.Fixture.ForEach {
    /// A `Collection.Protocol` conformer that is ALSO `Iterable`, with an Escapable
    /// `Index<Element>`. It matches BOTH `.forEach` operation gates.
    ///
    /// `makeIterator()` increments a shared counter, so a test can observe whether the
    /// Iterable-routed surface was taken. The expectation is that it is NOT — the
    /// Escapable-index conformer must resolve to the index-based default.
    struct Source<Element>: Collection.`Protocol`, Iterable, Sendable
    where Element: Sendable {
        let _elements: [Element]
        let _iteratorMade: Collection.Fixture.ForEach.Counter

        init(_ elements: [Element], counter: Collection.Fixture.ForEach.Counter) {
            self._elements = elements
            self._iteratorMade = counter
        }

        // Collection.Protocol — Escapable Index<Element>, index-based traversal.
        var startIndex: Index_Primitives.Index<Element> { .zero }
        var endIndex: Index_Primitives.Index<Element> {
            Index_Primitives.Index<Element>(_unchecked: Ordinal(UInt(_elements.count)))
        }
        subscript(_ position: Index_Primitives.Index<Element>) -> Element {
            _elements[Int(bitPattern: position)]
        }
        func index(after i: Index_Primitives.Index<Element>) -> Index_Primitives.Index<Element> {
            i.successor.saturating()
        }

        // Iterable — records that the Iterable surface was driven.
        borrowing func makeIterator() -> Iterator {
            _iteratorMade.bump()
            return Iterator(_elements)
        }

        struct Iterator: Iterating {
            let _elements: [Element]
            var _position: Int = 0
            init(_ elements: [Element]) { self._elements = elements }
            mutating func next() -> Element? {
                guard _position < _elements.count else { return nil }
                defer { _position += 1 }
                return _elements[_position]
            }
        }
    }

    /// Reference-type counter so a `borrowing makeIterator()` can record a side effect.
    final class Counter: @unchecked Sendable {
        private(set) var count = 0
        func bump() { count += 1 }
    }
}

// MARK: - Suite

extension Collection {
    @Suite
    struct `ForEach Test` {
        @Suite struct Disambiguation {}
    }
}

extension Collection.`ForEach Test`.Disambiguation {

    @Test
    func `forEach resolves unambiguously on an Escapable-index Iterable conformer`() {
        let counter = Collection.Fixture.ForEach.Counter()
        var source = Collection.Fixture.ForEach.Source([1, 2, 3], counter: counter)

        var collected: [Int] = []
        // If the two defaults were ambiguous for this conformer, this line would not
        // compile ("ambiguous use of 'callAsFunction'"). It compiling and running is
        // the disambiguation proof.
        source.forEach { collected.append($0) }

        #expect(collected == [1, 2, 3])
    }

    @Test
    func `Escapable-index Iterable conformer takes the index-based default, not the Iterable surface`() {
        let counter = Collection.Fixture.ForEach.Counter()
        var source = Collection.Fixture.ForEach.Source([10, 20], counter: counter)

        source.forEach { _ in }

        // The Iterable surface calls makeIterator(); the index-based default does not.
        // @_disfavoredOverload must route this conformer to the index-based default,
        // leaving the counter untouched.
        #expect(counter.count == 0)
    }

    @Test
    func `borrowing op also resolves to the index-based default`() {
        let counter = Collection.Fixture.ForEach.Counter()
        var source = Collection.Fixture.ForEach.Source([7, 8, 9], counter: counter)

        var collected: [Int] = []
        source.forEach.borrowing { collected.append($0) }

        #expect(collected == [7, 8, 9])
        #expect(counter.count == 0)
    }

    @Test
    func `index op remains available on the Escapable-index path`() {
        let counter = Collection.Fixture.ForEach.Counter()
        var source = Collection.Fixture.ForEach.Source([4, 5, 6], counter: counter)

        var visited: [Index_Primitives.Index<Int>] = []
        // `.index` exists ONLY on the Escapable-index default — the Iterable surface
        // intentionally omits it. Its availability here confirms the index-based
        // default is the one in scope.
        source.forEach.index { visited.append($0) }

        #expect(visited.count == 3)
        #expect(counter.count == 0)
    }

    @Test
    func `forEach is non-destructive on the Escapable-index path`() {
        let counter = Collection.Fixture.ForEach.Counter()
        var source = Collection.Fixture.ForEach.Source([1, 2], counter: counter)

        var first: [Int] = []
        source.forEach { first.append($0) }
        var second: [Int] = []
        source.forEach { second.append($0) }

        #expect(first == [1, 2])
        #expect(second == [1, 2])
    }
}
