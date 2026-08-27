//: [Précédent](@previous)
/*:
 # 04 — Concurrence moderne

 `async`/`await`, `actor`, `Task`, `Sendable`, annulation, races.

 Attendu utile :
 - **Exercice 3** — `process(_:)` peut recevoir une **grande** collection et
   doit rester **annulable de façon coopérative** pendant son exécution.
 */
import Foundation

// MARK: - 1.
func fetchInt(_ id: Int) async -> Int { id }

func total() async -> Int {
    let a = await fetchInt(1)
    let b = await fetchInt(2)
    let c = await fetchInt(3)
    return a + b + c
}

// MARK: - 2.
final class Cache {
    var storage: [String: Int] = [:]
    func set(_ key: String, _ value: Int) {
        storage[key] = value
    }
}

func fill(_ cache: Cache) async {
    await withTaskGroup(of: Void.self) { group in
        for i in 0..<1000 {
            group.addTask {
                cache.set("\(i)", i)
            }
        }
    }
}

// MARK: - 3.
func transform(_ item: Int) async -> Int {
    item * 2
}

func process(_ items: [Int]) async -> [Int] {
    var results: [Int] = []
    for item in items {
        results.append(await transform(item))
    }
    return results
}

// MARK: - 4.
final class FeedViewModel {
    var items: [String] = []
    func reload() {
        Task {
            self.items = ["a", "b", "c"]
        }
    }
}

//: [Suivant](@next)
