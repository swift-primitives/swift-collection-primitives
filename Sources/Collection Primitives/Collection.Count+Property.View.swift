public import Index_Primitives
public import Property_Primitives
public import Sequence_Primitives

/// Property.View extensions for counting operations on `Collection.Protocol` conformers.
extension Property.View
where Base: Collection.`Protocol` & ~Copyable, Tag == Collection.Count {

    /// Count elements matching predicate: `.count.where { }`
    ///
    /// Returns the number of elements satisfying the predicate.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3, 4, 5, 6])
    /// let evenCount = container.count.where { $0 % 2 == 0 }  // Count(3)
    /// ```
    ///
    /// - Parameter predicate: A closure that returns `true` for elements to count.
    /// - Returns: The count of matching elements.
    @inlinable
    public func `where`(_ predicate: (Base.Element) -> Bool) -> Index<Base.Element>.Count {
        var count = 0
        var iterator = unsafe base.pointee.makeIterator()
        while let element = iterator.next() {
            if predicate(element) { count += 1 }
        }
        return Index<Base.Element>.Count(__unchecked: count)
    }

    /// Count all elements: `.count.all`
    ///
    /// Returns the total number of elements in the collection.
    ///
    /// ```swift
    /// var container = MyContainer([1, 2, 3, 4, 5])
    /// let total = container.count.all  // Count(5)
    /// ```
    @inlinable
    public var all: Index<Base.Element>.Count {
        var count = 0
        var iterator = unsafe base.pointee.makeIterator()
        while iterator.next() != nil { count += 1 }
        return Index<Base.Element>.Count(__unchecked: count)
    }
}
