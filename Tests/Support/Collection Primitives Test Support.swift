public import Collection_Primitives
public import Index_Primitives
public import Iterable
public import Iterator_Chunk_Primitives

// MARK: - Fixture Namespace

extension Collection {
    /// Test fixtures for `Collection.Protocol` and related protocols.
    public enum Fixture {}
}

// MARK: - Source

extension Collection.Fixture {
    /// Minimal `Collection.Protocol` conformer for testing, backed by an array.
    public struct Source<Element>: Collection.`Protocol`, Sendable
    where Element: Sendable {
        @usableFromInline
        let _elements: [Element]

        /// Creates a fixture source from a copy of the provided elements.
        @inlinable
        public init(_ elements: [Element]) {
            self._elements = elements
        }
    }
}

extension Collection.Fixture.Source {
    /// The position of the first element in a non-empty collection.
    @inlinable
    public var startIndex: Index_Primitives.Index<Element> { .zero }

    /// The collection's "past the end" position.
    @inlinable
    public var endIndex: Index_Primitives.Index<Element> {
        Index_Primitives.Index<Element>(_unchecked: Ordinal(UInt(_elements.count)))
    }

    /// Accesses the element at the specified position.
    @inlinable
    public subscript(_ position: Index_Primitives.Index<Element>) -> Element {
        _elements[Int(bitPattern: position)]
    }

    /// Returns the position immediately after the given index.
    @inlinable
    public func index(after i: Index_Primitives.Index<Element>) -> Index_Primitives.Index<Element> {
        i.successor.saturating()
    }
}

// MARK: - Source: Iterable

extension Collection.Fixture.Source {
    /// Span-primitive `Iterable` witness: vends a fresh `Iterator.Chunk` over the array
    /// backing's span each call, so iteration is non-destructive (multipass). The backing
    /// is dense, contiguously-stored storage, which the chunk tier serves directly — no
    /// `Iterator.Materializing` adapter (that adapter is for span-less generators).
    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Chunk_Primitives.Iterator.Chunk<Element> {
        Iterator_Chunk_Primitives.Iterator.Chunk(_elements.span)
    }
}
