/// An extension that conforms the Heap class to the Sequence and IteratorProtocol protocols
/// This allows the heap object to be used in a for-in loop
extension Heap: Sequence, IteratorProtocol {
  /// A public method that returns the next element of the sequence
  /// It calls the nextPermutation method and returns its result
  public func next() -> Data? {
    self.nextPermutation()
  }
}
