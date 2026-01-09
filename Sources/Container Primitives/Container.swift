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

/// Namespace for container primitives.
public enum Container {
    /// Namespace for container error payloads.
    public enum Error {}

    /// Namespace for fixed-capacity array types.
    public enum Array<Element: ~Copyable>: ~Copyable {}
}
