/// A protocol that defines the requirements for a type that can be
/// permuted lexicographically
public protocol LexicalPermutation {
  /// A mutating function that rearranges the elements into the next
  /// lexicographically greater permutation
  /// Returns true if such a permutation exists, false otherwise
  mutating func nextPermutation() -> Bool

  /// A mutating function that rearranges the elements into the previous
  /// lexicographically smaller permutation
  /// Returns true if such a permutation exists, false otherwise
  mutating func prevPermutation() -> Bool
}
