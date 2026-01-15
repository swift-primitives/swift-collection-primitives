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
    /// A non-resizable array that is always fully initialized.
    ///
    /// Unlike standard `Array`, `Bounded` cannot grow or shrink after creation.
    /// All elements are initialized at construction time.
    @safe
    public struct Bounded: ~Copyable {
        @usableFromInline
        var storage: UnsafeMutablePointer<Element>

        /// The number of elements in the array.
        public let count: Int

        deinit {
            for i in 0..<count {
                unsafe (storage + i).deinitialize(count: 1)
            }
            if count > 0 {
                unsafe storage.deallocate()
            }
        }
    }
}

// MARK: - Initialization

extension Container.Array.Bounded {
    /// Creates a fixed array with the specified count, initializing each element.
    ///
    /// - Parameters:
    ///   - count: The number of elements. Must be non-negative.
    ///   - initializer: A closure that provides the element for each index.
    @inlinable
    public init(
        count: Int,
        initializingWith initializer: (Int) -> Element
    ) {
        precondition(count >= 0, "Count must be non-negative")

        if count == 0 {
            unsafe self.storage = UnsafeMutablePointer<Element>(bitPattern: MemoryLayout<Element>.alignment)!
            self.count = 0
            return
        }

        let storage = UnsafeMutablePointer<Element>.allocate(capacity: count)
        for i in 0..<count {
            unsafe (storage + i).initialize(to: initializer(i))
        }
        unsafe self.storage = storage
        self.count = count
    }
}

// MARK: - Properties

extension Container.Array.Bounded {
    /// Whether the array is empty.
    @inlinable
    public var isEmpty: Bool { count == 0 }
}

// MARK: - Subscript

extension Container.Array.Bounded {
    /// Accesses the element at the specified index.
    @inlinable
    public subscript(index: Int) -> Element {
        _read {
            precondition(index >= 0 && index < count, "Index out of bounds")
            yield unsafe storage[index]
        }
        _modify {
            precondition(index >= 0 && index < count, "Index out of bounds")
            yield &(unsafe storage[index])
        }
    }
}

// MARK: - Update

extension Container.Array.Bounded {
    /// Updates the element at the specified index.
    @inlinable
    public mutating func update<E: Swift.Error>(
        at index: Int,
        _ body: (inout Element) throws(E) -> Void
    ) throws(E) {
        precondition(index >= 0 && index < count, "Index out of bounds")
        try unsafe body(&storage[index])
    }
}

// MARK: - Span Access (Normative)

extension Container.Array.Bounded {
    /// Read-only span of the array elements.
    ///
    /// ## Lifetime Contract
    ///
    /// - The span is valid ONLY for the duration of the borrow of `self`.
    /// - The span MUST NOT be stored, returned, or allowed to escape.
    /// - The returned span is lifetime-dependent; the compiler is expected to diagnose escapes.
    /// - Violating this contract is undefined behavior.
    @inlinable
    public var span: Span<Element> {
        @_lifetime(borrow self)
        borrowing get {
            // Note: storage is always non-nil (sentinel pointer for empty case)
            unsafe Span(_unsafeStart: storage, count: count)
        }
    }

    /// Mutable span of the array elements.
    ///
    /// ## Lifetime Contract
    ///
    /// - The span is valid ONLY for the duration of the exclusive mutable borrow.
    /// - The span MUST NOT be stored, returned, or allowed to escape.
    /// - The returned span is lifetime-dependent; the compiler is expected to diagnose escapes.
    /// - No concurrent mutable borrows are permitted.
    /// - No mutable + immutable borrow overlap is permitted.
    /// - Violating this contract is undefined behavior.
    @inlinable
    public var mutableSpan: MutableSpan<Element> {
        @_lifetime(&self)
        mutating get {
            // Note: storage is always non-nil (sentinel pointer for empty case)
            unsafe MutableSpan(_unsafeStart: storage, count: count)
        }
    }
}

// MARK: - Pointer Access (Escape Hatch)

extension Container.Array.Bounded {
    /// Provides read-only access to the underlying contiguous storage.
    ///
    /// - Warning: This is an escape hatch for C interop. Prefer `span` for safe access.
    /// - Warning: The pointer must not escape the closure scope.
    @unsafe
    @inlinable
    public func withUnsafeBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        try unsafe body(UnsafeBufferPointer(start: count > 0 ? storage : nil, count: count))
    }

    /// Provides mutable access to the underlying contiguous storage.
    ///
    /// - Warning: This is an escape hatch for C interop. Prefer `mutableSpan` for safe access.
    /// - Warning: The pointer must not escape the closure scope.
    @unsafe
    @inlinable
    public mutating func withUnsafeMutableBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        try unsafe body(UnsafeMutableBufferPointer(start: count > 0 ? storage : nil, count: count))
    }
}

// MARK: - Sendable

extension Container.Array.Bounded: @unchecked Sendable where Element: Sendable {}
