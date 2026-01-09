// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-standards open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-standards project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Container.Array {
    /// A growable array with a compile-time initial capacity hint.
    ///
    /// Unlike `Fixed`, this array can grow unbounded. The generic parameter `N`
    /// specifies the initial allocation capacity when the first element is added.
    /// Subsequent growth uses a doubling strategy.
    public struct Growable<let N: Int>: ~Copyable {
        @usableFromInline
        var _storage: UnsafeMutablePointer<Element>?

        @usableFromInline
        var _count: Int

        @usableFromInline
        var _capacity: Int

        /// Creates an empty growable array.
        @inlinable
        public init() {
            self._storage = nil
            self._count = 0
            self._capacity = 0
        }

        deinit {
            if let storage = _storage {
                for i in 0..<_count {
                    (storage + i).deinitialize(count: 1)
                }
                storage.deallocate()
            }
        }
    }
}

// MARK: - Properties

extension Container.Array.Growable {
    /// The number of elements in the array.
    @inlinable
    public var count: Int { _count }

    /// Whether the array is empty.
    @inlinable
    public var isEmpty: Bool { _count == 0 }

    /// The current capacity of the array.
    @inlinable
    public var capacity: Int { _capacity }

    /// The initial capacity hint from the generic parameter.
    @inlinable
    public var initialCapacityHint: Int { N }
}

// MARK: - Core Operations

extension Container.Array.Growable {
    /// Appends an element to the array.
    @inlinable
    public mutating func append(_ element: consuming Element) {
        if _count >= _capacity {
            grow()
        }
        (_storage! + _count).initialize(to: element)
        _count += 1
    }

    /// Removes and returns the last element, or nil if empty.
    @inlinable
    public mutating func removeLast() -> Element? {
        guard _count > 0 else {
            return nil
        }
        _count -= 1
        return (_storage! + _count).move()
    }

    /// Removes all elements from the array.
    @inlinable
    public mutating func removeAll() {
        guard let storage = _storage else { return }
        for i in 0..<_count {
            (storage + i).deinitialize(count: 1)
        }
        _count = 0
    }

    @usableFromInline
    mutating func grow() {
        let newCapacity = _capacity == 0 ? max(N, 1) : _capacity * 2
        let newStorage = UnsafeMutablePointer<Element>.allocate(capacity: newCapacity)

        if let oldStorage = _storage {
            newStorage.moveInitialize(from: oldStorage, count: _count)
            oldStorage.deallocate()
        }

        _storage = newStorage
        _capacity = newCapacity
    }
}

// MARK: - Iteration

extension Container.Array.Growable {
    /// Iterates over all elements.
    @inlinable
    public func forEach(_ body: (borrowing Element) throws -> Void) rethrows {
        guard let storage = _storage else { return }
        for i in 0..<_count {
            try body((storage + i).pointee)
        }
    }

    /// Removes and consumes all elements.
    @inlinable
    public mutating func drain(_ body: (consuming Element) -> Void) {
        guard let storage = _storage else { return }
        for i in 0..<_count {
            body((storage + i).move())
        }
        _count = 0
    }
}

// MARK: - Sendable

extension Container.Array.Growable: @unchecked Sendable where Element: Sendable {}

// MARK: - Convenience Typealiases

extension Container.Array {
    public typealias Small1 = Growable<1>
    public typealias Small4 = Growable<4>
    public typealias Small8 = Growable<8>
}
