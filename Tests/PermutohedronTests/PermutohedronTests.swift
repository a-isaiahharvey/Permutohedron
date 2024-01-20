import XCTest

@testable import Permutohedron

final class PermutohedronTests: XCTestCase {
  func testLexical() throws {
    var data = [1, 2, 3]
    let _ = data.nextPermutation()
    XCTAssert(data == [1, 3, 2])
    let _ = data.nextPermutation()
    XCTAssert(data == [2, 1, 3])
    let _ = data.prevPermutation()
    XCTAssert(data == [1, 3, 2])
    let _ = data.prevPermutation()
    XCTAssert(data == [1, 2, 3])
    XCTAssert(!data.prevPermutation())
    var c = 0
    while data.nextPermutation() {
      c += 1
    }
    XCTAssertEqual(c, 5)
  }

  func testPermutationsBreak() throws {
    var data = Array.init(repeating: 0, count: 8)
    var i = 0
    let _ = try? heapRecursive(
      &data,
      { _ in
        i += 1
        if i >= 10_000 {
          return i
        } else {
          return nil
        }
      })
    XCTAssertEqual(i, 10_000)
  }

  func testFirstAndReset() throws {
    var data = [1, 2, 3]
    let heap = Heap(&data)
    var perm123 = [[1, 2, 3], [2, 1, 3], [3, 1, 2], [1, 3, 2], [2, 3, 1], [3, 2, 1]]
    XCTAssertEqual(Array(heap), perm123)

    heap.reset()
    perm123.reverse()
    XCTAssertEqual(Array(heap), perm123)
  }

  func testPermutations0To6() throws {
    var data = [Int](repeating: 0, count: 6)
    for n in (0..<data.count) {
      let count = factorial(n)
      data = data.enumerated().map({ index, elmt in
        return index + 1
      })
      var permutations = Array(Heap(&data[..<n]))
      XCTAssertEqual(permutations.count, count)
      permutations.removeDuplicates()
      XCTAssertEqual(permutations.count, count)
      XCTAssert(permutations.allSatisfy({ perm in perm.count == n }))
      XCTAssert(
        permutations.allSatisfy({ perm in
          (1..<n + 1).allSatisfy({ i in
            perm.contains { $0 == i }
          })
        }))
    }
  }

  func testCountPermutationsIter() throws {
    var data = [Int](repeating: 0, count: 10)

    for n in (0..<data.count + 1) {
      let count = factorial(n)
      let permutations = Heap(&data[..<n])
      var i = 0
      while permutations.nextPermutation() != nil {
        i += 1
      }

      XCTAssertEqual(i, count)

    }
  }

  func testCountPermutationsRecursive() throws {
    var data = [Int](repeating: 0, count: 10)

    for n in (0..<data.count + 1) {
      let count = factorial(n)
      var i = 0
      let _: Int? = try heapRecursive(
        &data[..<n],
        { _ in
          i += 1
          return nil
        })
      XCTAssertEqual(i, count)

    }
  }

  func testPermutations0To6Recursive() throws {
    var data = [Int](repeating: 0, count: 6)
    for n in 0..<data.count {
      let count = factorial(n)
      data = data.enumerated().map({ index, _ in return index + 1 })
      var permutations: [ArraySlice<Int>] = Array()
      let _: Void? = try? heapRecursive(
        &data[..<n],
        { elmt in
          permutations.append(elmt)
          return nil
        })
      XCTAssertEqual(permutations.count, count)
      permutations.removeDuplicates()
      XCTAssertEqual(permutations.count, count)
      XCTAssert(permutations.allSatisfy({ perm in perm.count == n }))
      XCTAssert(
        permutations.allSatisfy({ perm in
          (1..<n + 1).allSatisfy({ i in
            perm.contains { $0 == i }
          })
        }))

    }
  }
}

extension Array where Element: Hashable {
  func removingDuplicates() -> [Element] {
    var addedDict = [Element: Bool]()

    return filter {
      addedDict.updateValue(true, forKey: $0) == nil
    }
  }

  mutating func removeDuplicates() {
    self = self.removingDuplicates()
  }
}
