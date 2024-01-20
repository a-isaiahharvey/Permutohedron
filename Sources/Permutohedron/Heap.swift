// A constant that defines the maximum size of the heap data structure
public let maxHeap: Int = 16

/// A generic class that implements a heap data structure
/// The heap can store any type of data that conforms to the MutableCollection protocol
/// The elements of the data must also conform to the Comparable protocol
/// The data is stored as an array with integer indices
public class Heap<Data, Element>
where Data: MutableCollection, Data.Element == Element, Data.Index == Int {
  /// A property that holds the data of the heap
  var data: Data
  /// A property that keeps track of the current index for generating permutations
  var n: UInt32
  /// A property that stores the counts of swaps for each index
  var c: [UInt8]
  /// A property that stores the type of the elements
  var _element: Element.Type

  /// A public initializer that takes a reference to a data collection
  /// and creates a heap object with it
  /// The data collection must have a size less than or equal to a constant maxHeap
  public init(_ data: inout Data) {
    precondition(data.count <= maxHeap)
    self.data = data
    self.c = [UInt8].init(repeating: 0, count: maxHeap - 1)
    self.n = UInt32.max
    self._element = Element.self
  }
}

/// // An extension that adds some methods to the Heap class
extension Heap {
  /// A public method that returns the data of the heap
  public func get() -> Data {
    return self.data
  }

  /// A public method that returns a mutable pointer to the data of the heap
  public func getMut() -> UnsafeMutablePointer<Data> {
    return withUnsafeMutablePointer(to: &self.data, { $0 })
  }

  /// A public method that resets the state of the heap
  /// It sets the current index to the maximum value of UInt32
  /// and sets all the counts of swaps to zero
  public func reset() {
    self.n = UInt32.max
    for i in 0..<self.c.count {
      self.c[i] = 0
    }
  }

  /// A public method that generates the next lexicographic permutation of the data
  /// It uses the algorithm described by B. R. Heap in 1963
  /// It returns the permuted data if it exists, or nil otherwise
  public func nextPermutation() -> Data? {
    // If the current index is the maximum value of UInt32
    // it means that this is the first call to this method
    // so it returns the original data
    if self.n == UInt32.max {
      self.n = 0
      return self.data
    } else {
      // Otherwise, it loops through the indices from 0 to the size of the data
      // and performs the following steps:
      while 1 + Int(self.n) < self.data.count {
        // It stores the current index as n and converts it to an integer as nu
        let n = self.n
        let nu = Int(n)

        // it means that there are still some permutations left for this index
        if self.c[nu] <= n {
          // It computes the index j to swap with nu + 1
          // If nu is even, j is equal to the count of swaps for nu
          // If nu is odd, j is equal to zero
          let j = nu % 2 == 0 ? Int(c[nu]) : 0
          // It swaps the elements at indices j and nu + 1
          self.data.swapAt(j, nu + 1)
          // It increments the count of swaps for nu by one
          self.c[nu] += 1
          // It resets the current index to zero
          self.n = 0
          // It returns the permuted data
          return self.data
        } else {
          // If the count of swaps for the current index is greater than the index
          // it means that there are no more permutations left for this index
          // so it resets the count of swaps for nu to zero
          self.c[nu] = 0
          // and increments the current index by one
          self.n += 1
        }
      }

      // If the loop exits, it means that there are no more permutations left for any index
      // so it returns nil
      return nil
    }
  }
}

/// A generic function that applies a closure to a heap data structure
/// The function uses a recursive algorithm to generate all the permutations
/// of the heap and pass them to the closure
public func heapRecursive<Heap: MutableCollection<T>, T: Comparable, R>(
  _ xs: inout Heap, _ f: (inout Heap) throws -> R?
)
  throws -> R? where Heap.Element == T, Heap.Index == Int
{
  switch xs.count {
  // If the heap is empty or has one element, there is only one permutation
  // so apply the closure to the heap and return its result

  case 0, 1:
    return try f(&xs)

  // If the heap has two elements, there are two permutations
  // so apply the closure to the heap and return its result if it is not nil
  // otherwise swap the elements and apply the closure again and return its result
  case 2:
    if let x = try f(&xs) {
      return x
    }
    xs.swapAt(0, 1)
    return try f(&xs)

  // If the heap has more than two elements, use the heapUnrolled function
  // to generate the permutations and apply the closure to them
  case let n:
    return try heapUnrolled(n, &xs, f)
  }

}

/// A helper function that generates the permutations of a heap
/// using an iterative algorithm
/// It takes the size of the heap, a reference to the heap, and a closure
/// It returns the first non-nil value returned by the closure
/// or nil if none exists
func heapUnrolled<Heap: MutableCollection<T>, T: Comparable, R>(
  _ n: Int, _ xs: inout Heap, _ f: (inout Heap) throws -> R?
) throws -> R? where Heap.Element == T, Heap.Index == Int {
  #if DEBUG
    assert(n >= 3)
  #endif

  switch n {

  // If the heap has three elements, there are six permutations
  // so apply the closure to each permutation and return the first non-nil result
  // The permutations are generated by swapping the first element with the others
  // and then reversing the order of the last two elements
  case 3:
    if let x = try f(&xs) {
      return x
    }

    xs.swapAt(0, 1)

    if let x = try f(&xs) {
      return x
    }

    xs.swapAt(0, 2)

    if let x = try f(&xs) {
      return x
    }

    xs.swapAt(0, 1)

    if let x = try f(&xs) {
      return x
    }

    xs.swapAt(0, 2)

    if let x = try f(&xs) {
      return x
    }

    xs.swapAt(0, 1)

    return try f(&xs)

  case let n:
    for i in (0..<n - 1) {
      if let x = try heapUnrolled(n - 1, &xs, f) {
        return x
      }
      let j = n % 2 == 0 ? i : 0
      xs.swapAt(j, n - 1)
    }
    return try heapUnrolled(n - 1, &xs, f)
  }
}
