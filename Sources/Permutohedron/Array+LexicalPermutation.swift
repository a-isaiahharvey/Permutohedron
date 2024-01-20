/// An extension that conforms the Array type to the LexicalPermutation protocol
/// The elements of the array must be Comparable
extension Array: LexicalPermutation where Element: Comparable {
  /// A mutating function that rearranges the elements of the array
  /// into the next lexicographically greater permutation
  /// Returns true if such a permutation exists, false otherwise
  public mutating func nextPermutation() -> Bool {
    // If the array has less than two elements, there is no next permutation
    if self.count < 2 {
      return false
    }

    // Find the largest index i such that self[i - 1] < self[i]
    // If no such index exists, the array is sorted in descending order
    // and there is no next permutation
    var i = self.count - 1
    while i > 0 && self[i - 1] >= self[i] {
      i -= 1
    }

    if i == 0 {
      return false
    }

    // Find the largest index j such that j >= i and self[j] > self[i - 1]
    // Such a j must exist, since i - 1 is the first index from the right
    // that is not in descending order
    var j = self.count - 1
    while j >= i && self[j] <= self[i - 1] {
      j -= 1
    }

    // Swap self[i - 1] and self[j]
    // This puts the pivot element (self[i - 1]) in its correct position
    // in the next permutation
    self.swapAt(j, i - 1)

    // Reverse the suffix of the array starting at index i
    // This creates the smallest possible suffix with the remaining elements
    // and completes the next permutation
    self[i...].reverse()

    return true
  }

  /// A mutating function that rearranges the elements of the array
  /// into the previous lexicographically smaller permutation
  /// Returns true if such a permutation exists, false otherwise
  public mutating func prevPermutation() -> Bool {
    // If the array has less than two elements, there is no previous permutation
    if self.count < 2 {
      return false
    }

    // Find the largest index i such that self[i - 1] > self[i]
    // If no such index exists, the array is sorted in ascending order
    // and there is no previous permutation
    var i = self.count - 1
    while i > 0 && self[i - 1] <= self[i] {
      i -= 1
    }

    if i == 0 {
      return false
    }

    // Reverse the suffix of the array starting at index i
    // This creates the largest possible suffix with the remaining elements
    self[i...].reverse()

    // Find the largest index j such that j >= i and self[j - 1] < self[i - 1]
    // Such a j must exist, since i - 1 is the first index from the right
    // that is not in ascending order
    var j = self.count - 1
    while j >= i && self[j - 1] < self[i - 1] {
      j -= 1
    }

    // Swap self[i - 1] and self[j]
    // This puts the pivot element (self[i - 1]) in its correct position
    // in the previous permutation
    self.swapAt(i - 1, j)

    return true
  }
}
