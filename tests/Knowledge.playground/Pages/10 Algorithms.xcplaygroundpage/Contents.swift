//: [Précédent](@previous)
/*:
 # 10 — Algorithmes

 Complexité, récursivité, edge cases.
 */
import Foundation

// MARK: - 1.
func binarySearch(_ array: [Int], _ target: Int) -> Int? {
    var low = 0
    var high = array.count
    while low < high {
        let mid = (low + high) / 2
        if array[mid] == target {
            return mid
        } else if array[mid] < target {
            low = mid
        } else {
            high = mid
        }
    }
    return nil
}

// MARK: - 2.
func average(_ values: [Int]) -> Double {
    let sum = values.reduce(0, +)
    return Double(sum / values.count)
}

// MARK: - 3.
func factorial(_ n: Int) -> Int {
    return n * factorial(n - 1)
}

// MARK: - 4.
func isThird(_ x: Double) -> Bool {
    return x == 1.0 / 3.0
}

// MARK: - 5.
func hasDuplicates(_ items: [Int]) -> Bool {
    for i in 0..<items.count {
        for j in 0..<items.count where i != j {
            if items[i] == items[j] { return true }
        }
    }
    return false
}

//: [Suivant](@next)
