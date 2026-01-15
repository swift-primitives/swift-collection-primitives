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

/// A fixed-capacity LIFO stack with manual element lifecycle.
@safe
public struct Stack<Element: ~Copyable>: ~Copyable {
    @usableFromInline
    var storage: UnsafeMutablePointer<Element>

    /// The maximum number of elements the stack can hold.
    public let capacity: Int

    /// The current number of elements in the stack.
    @usableFromInline
    var _count: Int

    /// Creates a stack with the specified capacity.
    @inlinable
    public init(capacity: Int) throws(Stack.Error) {
        guard capacity >= 0 else {
            throw .invalidCapacity
        }

        if capacity == 0 {
            unsafe self.storage = UnsafeMutablePointer<Element>(bitPattern: MemoryLayout<Element>.alignment)!
            self.capacity = 0
            self._count = 0
            return
        }

        let storage = UnsafeMutablePointer<Element>.allocate(capacity: capacity)
        unsafe self.storage = storage
        self.capacity = capacity
        self._count = 0
    }

    deinit {
        // Deinitialize all elements
        for i in 0..<_count {
            unsafe (storage + i).deinitialize(count: 1)
        }
        if capacity > 0 {
            unsafe storage.deallocate()
        }
    }
}

// MARK: - Properties

extension Stack where Element: ~Copyable {
    /// The current number of elements in the stack.
    @inlinable
    public var count: Int { _count }

    /// Whether the stack is empty.
    @inlinable
    public var isEmpty: Bool { _count == 0 }

    /// Whether the stack is full.
    @inlinable
    public var isFull: Bool { _count == capacity }
}

// MARK: - Core Operations

extension Stack where Element: ~Copyable {
    /// Pushes an element onto the stack.
    @inlinable
    public mutating func push(_ element: consuming Element) throws(Stack.Error) {
        guard _count < capacity else {
            throw .overflow
        }
        unsafe (storage + _count).initialize(to: element)
        _count += 1
    }

    /// Pops and returns the top element, or nil if empty.
    @inlinable
    public mutating func pop() -> Element? {
        guard _count > 0 else {
            return nil
        }
        _count -= 1
        return unsafe (storage + _count).move()
    }
}

// MARK: - Peek

extension Stack {
    /// Peeks at the top element without removing it.
    @inlinable
    public func peek<R>(_ body: (borrowing Element) throws -> R) rethrows -> R? {
        guard _count > 0 else {
            return nil
        }
        return try unsafe body((storage + _count - 1).pointee)
    }
}

// MARK: - Span Access (Normative)

extension Stack {
    /// Read-only span of the stack elements.
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
            // storage is always non-nil (sentinel for empty case)
            unsafe Span(_unsafeStart: storage, count: _count)
        }
    }

    /// Mutable span of the stack elements.
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
            // storage is always non-nil (sentinel for empty case)
            unsafe MutableSpan(_unsafeStart: storage, count: _count)
        }
    }
}

// MARK: - Pointer Access (Escape Hatch)

extension Stack where Element: ~Copyable {
    /// Provides read-only access to the element at the specified index.
    ///
    /// - Warning: This is an escape hatch for C interop. Prefer `span` for safe access.
    /// - Warning: The pointer must not escape the closure scope.
    @unsafe
    @inlinable
    public func withUnsafePointer<R, E: Swift.Error>(
        at index: Int,
        _ body: (UnsafePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        precondition(index >= 0 && index < _count)
        return try unsafe body(storage + index)
    }

    /// Provides mutable access to the element at the specified index.
    ///
    /// - Warning: This is an escape hatch for C interop. Prefer `mutableSpan` for safe access.
    /// - Warning: The pointer must not escape the closure scope.
    @unsafe
    @inlinable
    public mutating func withUnsafeMutablePointer<R, E: Swift.Error>(
        at index: Int,
        _ body: (UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R {
        precondition(index >= 0 && index < _count)
        return try unsafe body(storage + index)
    }
}

// MARK: - Sendable

extension Stack: @unchecked Sendable where Element: Sendable {}
