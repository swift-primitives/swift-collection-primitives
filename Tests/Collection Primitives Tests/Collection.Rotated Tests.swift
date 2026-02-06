// Collection.Rotated Tests.swift

import Testing
@testable import Collection_Primitives
import Index_Primitives
import Index_Primitives_Test_Support

@Suite("Collection.Rotated")
struct CollectionRotatedTests {

    // MARK: - Basic Rotation

    @Test("rotation by 0 returns original order")
    func rotationByZero() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(base: original, startOffset: .zero)

        #expect(Array(rotated) == ["a", "b", "c", "d"])
    }

    @Test("rotation by 1 shifts elements left")
    func rotationByOne() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(base: original, startOffset: .one)

        #expect(Array(rotated) == ["b", "c", "d", "a"])
    }

    @Test("rotation by 2 shifts elements left by 2")
    func rotationByTwo() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(base: original, startOffset: 2)

        #expect(Array(rotated) == ["c", "d", "a", "b"])
    }

    @Test("rotation by count returns original order")
    func rotationByCount() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(base: original, startOffset: 4)

        #expect(Array(rotated) == ["a", "b", "c", "d"])
    }

    @Test("rotation normalizes offset modulo count")
    func rotationNormalizesOffset() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(base: original, startOffset: 5)

        // 5 % 4 = 1, so same as rotation by 1
        #expect(Array(rotated) == ["b", "c", "d", "a"])
    }

    @Test("large offset is normalized")
    func largeOffsetNormalized() {
        let original = [1, 2, 3]
        let rotated = Collection.Rotated(base: original, startOffset: 100)

        // 100 % 3 = 1
        #expect(Array(rotated) == [2, 3, 1])
    }

    // MARK: - Empty Collection

    @Test("empty collection rotation")
    func emptyCollectionRotation() {
        let empty: [Int] = []
        let rotated = Collection.Rotated(base: empty, startOffset: 5)

        #expect(rotated.isEmpty)
        #expect(rotated.count == 0)
    }

    // MARK: - Single Element

    @Test("single element rotation")
    func singleElementRotation() {
        let single = [42]
        let rotated = Collection.Rotated(base: single, startOffset: .one)

        #expect(Array(rotated) == [42])
    }

    // MARK: - Collection Properties

    @Test("count matches base count")
    func countMatchesBase() {
        let original = [1, 2, 3, 4, 5]
        let rotated = Collection.Rotated(base: original, startOffset: 2)

        #expect(rotated.count == original.count)
    }

    @Test("startIndex is zero")
    func startIndexIsZero() {
        let rotated = Collection.Rotated(base: [1, 2, 3], startOffset: .one)

        #expect(rotated.startIndex == .zero)
    }

    @Test("endIndex equals count")
    func endIndexEqualsCount() {
        let rotated = Collection.Rotated(base: [1, 2, 3], startOffset: .one)
        let expected: Index<Int> = 3

        #expect(rotated.endIndex == expected)
    }

    // MARK: - RandomAccessCollection

    @Test("subscript access at various positions")
    func subscriptAccess() {
        let original = ["a", "b", "c", "d", "e"]
        let rotated = Collection.Rotated(base: original, startOffset: 2)

        // Rotated: ["c", "d", "e", "a", "b"]
        let idx0: Index<String> = 0

        #expect(rotated[idx0] == "c")
        #expect(rotated[idx0 + 1] == "d")
        #expect(rotated[idx0 + 2] == "e")
        #expect(rotated[idx0 + 3] == "a")
        #expect(rotated[idx0 + 4] == "b")
    }

    @Test("index arithmetic")
    func indexArithmetic() {
        let rotated = Collection.Rotated(base: [1, 2, 3, 4, 5], startOffset: .one)

        let idx0: Index<Int> = .zero
        let idx1 = idx0 + .one
        let idx2 = idx0 + 2
        let idx3 = idx0 + 3
        let idx4 = idx0 + 4

        #expect(rotated.index(after: idx0) == idx1)
        #expect(rotated.index(before: idx3) == idx2)
        #expect(rotated.index(idx0, offsetBy: 3) == idx3)
        #expect(rotated.distance(from: idx1, to: idx4) == 3)
    }

    @Test("reversed iteration")
    func reversedIteration() {
        let original = [1, 2, 3, 4]
        let rotated = Collection.Rotated(base: original, startOffset: .one)

        // Rotated: [2, 3, 4, 1], reversed: [1, 4, 3, 2]
        #expect(Array(rotated.reversed()) == [1, 4, 3, 2])
    }

    // MARK: - Composition

    @Test("nested rotation")
    func nestedRotation() {
        let original = [1, 2, 3, 4]
        let rotated1 = Collection.Rotated(base: original, startOffset: .one)
        let rotated2 = Collection.Rotated(base: rotated1, startOffset: .one)

        // First rotation: [2, 3, 4, 1]
        // Second rotation: [3, 4, 1, 2]
        #expect(Array(rotated2) == [3, 4, 1, 2])
    }

    // MARK: - Different Base Types

    @Test("works with ArraySlice")
    func worksWithArraySlice() {
        let array = [0, 1, 2, 3, 4, 5]
        let slice = array[1..<5]  // [1, 2, 3, 4]
        let rotated = Collection.Rotated(base: slice, startOffset: .one)

        #expect(Array(rotated) == [2, 3, 4, 1])
    }
}
