// A public function that computes the factorial of a given integer
// It uses the reduce method to multiply all the integers from 1 to n
public func factorial(_ n: Int) -> Int {
  (1..<n + 1).reduce(
    1,
    { a, b in
      a * b
    })
}
