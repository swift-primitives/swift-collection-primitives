// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Container {
    /// Accessor for safe collection operations.
    ///
    /// All subscripts return `Optional`, returning `nil` for out-of-bounds access
    /// instead of trapping.
    ///
    /// Accessed via the `.safe` property on any `Collection`.
    public struct Safe<Base: Collection> {
        @usableFromInline
        let base: Base

        @usableFromInline
        init(_ base: Base) {
            self.base = base
        }
    }
}

extension Container.Safe: Sendable where Base: Sendable {}
