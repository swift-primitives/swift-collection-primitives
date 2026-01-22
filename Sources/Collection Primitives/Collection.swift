/// Namespace for collection-related protocols and types.
///
/// `Collection` provides a namespace for protocols and types that support
/// indexed, multi-pass iteration over elements. Unlike stdlib's `Collection`
/// protocol, these protocols support `~Copyable` conformers.
///
/// ## Protocols
///
/// | Protocol | Description |
/// |----------|-------------|
/// | `Collection.Protocol` | Indexed, multi-pass iteration (extends `Sequence.Protocol`) |
/// | `Collection.Clearable` | Collection that can be cleared for consuming iteration |
///
/// ## Tags
///
/// | Tag | Description |
/// |-----|-------------|
/// | `Collection.ForEach` | Tag for `.forEach` property extensions |
///
/// ## Types
///
/// | Type | Description |
/// |------|-------------|
/// | `Collection.Rotated` | A rotated view of a collection |
public struct Collection: Sendable {}
