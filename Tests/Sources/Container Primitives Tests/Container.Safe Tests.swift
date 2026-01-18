// Container.Safe Tests.swift
// swift-container-primitives
//
// Tests for safe collection access operations.

import Testing
@testable import Container_Primitives

// MARK: - Element Access Tests

@Suite("Container.Safe Element Access")
struct SafeElementAccessTests {

    @Test("access valid index returns element")
    func accessValidIndex() {
        let array = [1, 2, 3, 4, 5]
        #expect(array.safe[0] == 1)
        #expect(array.safe[2] == 3)
        #expect(array.safe[4] == 5)
    }

    @Test("access out of bounds returns nil")
    func accessOutOfBounds() {
        let array = [1, 2, 3]
        #expect(array.safe[3] == nil)
        #expect(array.safe[10] == nil)
        #expect(array.safe[100] == nil)
    }

    @Test("access negative index returns nil")
    func accessNegativeIndex() {
        let array = [1, 2, 3]
        #expect(array.safe[-1] == nil)
        #expect(array.safe[-100] == nil)
    }

    @Test("access empty array returns nil")
    func accessEmptyArray() {
        let array: [Int] = []
        #expect(array.safe[0] == nil)
    }

    @Test("access single element array")
    func accessSingleElement() {
        let array = [42]
        #expect(array.safe[0] == 42)
        #expect(array.safe[1] == nil)
    }
}

// MARK: - Range Access Tests

@Suite("Container.Safe Range Access")
struct SafeRangeAccessTests {

    @Test("access valid range returns subsequence")
    func accessValidRange() {
        let array = [1, 2, 3, 4, 5]
        #expect(array.safe[1..<3] == [2, 3][...])
        #expect(array.safe[0..<5] == [1, 2, 3, 4, 5][...])
    }

    @Test("access empty range returns empty subsequence")
    func accessEmptyRange() {
        let array = [1, 2, 3]
        let result = array.safe[1..<1]
        #expect(result != nil)
        #expect(result?.isEmpty == true)
    }

    @Test("access out of bounds range returns nil")
    func accessOutOfBoundsRange() {
        let array = [1, 2, 3]
        #expect(array.safe[0..<10] == nil)
        #expect(array.safe[5..<10] == nil)
    }

    @Test("access range with negative lower bound returns nil")
    func accessRangeNegativeLower() {
        let array = [1, 2, 3]
        #expect(array.safe[-1..<2] == nil)
    }

    @Test("access range on empty array")
    func accessRangeEmptyArray() {
        let array: [Int] = []
        #expect(array.safe[0..<0] != nil)  // Empty range is valid
        #expect(array.safe[0..<1] == nil)  // Out of bounds
    }
}

// MARK: - Integer Index Conversion Tests

@Suite("Container.Safe Integer Conversion")
struct SafeIntegerConversionTests {

    @Test("access with UInt index")
    func accessWithUInt() {
        let array = [10, 20, 30]
        let index: UInt = 1
        #expect(array.safe[index] == 20)
    }

    @Test("access with UInt64 index")
    func accessWithUInt64() {
        let array = [10, 20, 30]
        let index: UInt64 = 2
        #expect(array.safe[index] == 30)
    }

    @Test("access with huge UInt64 returns nil")
    func accessWithHugeUInt64() {
        let array = [10, 20, 30]
        let index: UInt64 = UInt64.max
        #expect(array.safe[index] == nil)
    }

    @Test("access with Int8 index")
    func accessWithInt8() {
        let array = [10, 20, 30]
        let index: Int8 = 0
        #expect(array.safe[index] == 10)
    }

    @Test("access with negative Int8 returns nil")
    func accessWithNegativeInt8() {
        let array = [10, 20, 30]
        let index: Int8 = -1
        #expect(array.safe[index] == nil)
    }

    @Test("UInt64 range access")
    func uint64RangeAccess() {
        let array = [10, 20, 30, 40, 50]
        let start: UInt64 = 1
        let end: UInt64 = 4
        #expect(array.safe[start..<end] == [20, 30, 40][...])
    }

    @Test("huge UInt64 range returns nil")
    func hugeUInt64Range() {
        let array = [10, 20, 30]
        let start: UInt64 = 0
        let end: UInt64 = UInt64.max
        #expect(array.safe[start..<end] == nil)
    }
}

// MARK: - ArraySlice Tests

@Suite("Container.Safe ArraySlice")
struct SafeArraySliceTests {

    @Test("access ArraySlice with offset indices")
    func accessArraySliceWithOffset() {
        let array = [0, 1, 2, 3, 4, 5]
        let slice = array[2..<5]  // [2, 3, 4] with indices 2, 3, 4

        #expect(slice.safe[2] == 2)
        #expect(slice.safe[3] == 3)
        #expect(slice.safe[4] == 4)
        #expect(slice.safe[0] == nil)  // Out of slice bounds
        #expect(slice.safe[5] == nil)  // Out of slice bounds
    }

    @Test("range access on ArraySlice")
    func rangeAccessOnArraySlice() {
        let array = [0, 1, 2, 3, 4, 5]
        let slice = array[2..<5]

        #expect(slice.safe[2..<4] == [2, 3][...])
        #expect(slice.safe[0..<2] == nil)  // Before slice start
    }
}

// MARK: - String Tests

@Suite("Container.Safe String")
struct SafeStringTests {

    @Test("access String.UTF8View safely")
    func accessStringUTF8() {
        let string = "Hello"
        let utf8 = string.utf8

        #expect(utf8.safe[utf8.startIndex] == UInt8(ascii: "H"))
    }

    @Test("access bytes array safely")
    func accessBytesArray() {
        let bytes: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F]  // "Hello"
        #expect(bytes.safe[0] == 0x48)
        #expect(bytes.safe[4] == 0x6F)
        #expect(bytes.safe[5] == nil)
    }
}

// MARK: - Sendable Tests

@Suite("Container.Safe Sendable")
struct SafeSendableTests {

    @Test("accessor is Sendable when base is Sendable")
    func accessorIsSendable() async {
        let array = [1, 2, 3]
        let safe = array.safe

        let task = Task {
            safe[1]
        }

        let result = await task.value
        #expect(result == 2)
    }
}

// MARK: - Edge Cases

@Suite("Container.Safe Edge Cases")
struct SafeEdgeCaseTests {

    @Test("access at Int.max returns nil")
    func accessAtIntMax() {
        let array = [1, 2, 3]
        #expect(array.safe[Int.max] == nil)
    }

    @Test("large array access")
    func largeArrayAccess() {
        let array = Array(0..<10000)
        #expect(array.safe[9999] == 9999)
        #expect(array.safe[10000] == nil)
    }

    @Test("repeated safe access")
    func repeatedSafeAccess() {
        let array = [1, 2, 3]

        // Multiple accesses should work consistently
        for _ in 0..<100 {
            #expect(array.safe[1] == 2)
            #expect(array.safe[5] == nil)
        }
    }

    @Test("safe access does not modify original")
    func safeAccessDoesNotModify() {
        let array = [1, 2, 3]
        _ = array.safe[0]
        _ = array.safe[100]
        #expect(array == [1, 2, 3])
    }
}

// MARK: - Practical Use Cases

@Suite("Container.Safe Practical")
struct SafePracticalTests {

    @Test("binary data offset access")
    func binaryDataOffsetAccess() {
        let data: [UInt8] = [0x00, 0x01, 0x02, 0x03, 0x04]
        let offset: UInt64 = 2

        if let byte = data.safe[offset] {
            #expect(byte == 0x02)
        } else {
            Issue.record("Expected valid byte")
        }
    }

    @Test("optional chaining with safe access")
    func optionalChaining() {
        let arrays: [[Int]?] = [[1, 2, 3], nil, [4, 5]]

        let result = arrays[0]?.safe[1]
        #expect(result == 2)

        let nilResult = arrays[1]?.safe[0]
        #expect(nilResult == nil)
    }

    @Test("guard let pattern")
    func guardLetPattern() {
        let array = [10, 20, 30]

        func getValue(at index: Int) -> Int? {
            guard let value = array.safe[index] else {
                return nil
            }
            return value * 2
        }

        #expect(getValue(at: 1) == 40)
        #expect(getValue(at: 5) == nil)
    }

    @Test("map with safe access")
    func mapWithSafeAccess() {
        let source = [10, 20, 30]
        let indices = [0, 2, 5, 1]

        let results = indices.compactMap { source.safe[$0] }
        #expect(results == [10, 30, 20])
    }
}
