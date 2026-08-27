//: [Précédent](@previous)
/*:
 # 01 — Fondamentaux Swift

 Optionals, sémantique valeur/référence, collections, closures, enums, gestion d'erreurs.

 Repère, explique et corrige tout ce qui ne va pas ci-dessous.
 */
import Foundation

// MARK: - 1.
func firstEven(_ numbers: [Int]) -> Int {
    return numbers.filter { $0 % 2 == 0 }.first!
}

// MARK: - 2.
struct Wallet {
    var balance: Int
}

func topUp(_ wallet: Wallet, amount: Int) {
    var wallet = wallet
    wallet.balance += amount
}

// MARK: - 3.
func averageAge(_ people: [String: Int]) -> Int {
    let total = people.values.reduce(0, +)
    return total / people.count
}

// MARK: - 4.
final class Counter {
    var count = 0
    lazy var increment: () -> Void = {
        self.count += 1
    }
}

// MARK: - 5.
enum Direction {
    case north, south, east, west
}

func describe(_ d: Direction) -> String {
    switch d {
    case .north: return "Nord"
    case .south: return "Sud"
    default: return "Autre"
    }
}

// MARK: - 6.
enum ParseError: Error { case invalid }

func parse(_ s: String) -> Int {
    do {
        guard let value = Int(s) else { throw ParseError.invalid }
        return value
    } catch {
        return 0
    }
}

//: [Suivant](@next)
