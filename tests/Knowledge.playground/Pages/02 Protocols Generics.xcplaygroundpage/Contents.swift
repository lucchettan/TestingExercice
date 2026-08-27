//: [Précédent](@previous)
/*:
 # 02 — Protocoles & Génériques

 POP, génériques, associated types, `some` vs `any`.
 */
import Foundation

// MARK: - 1.
protocol Shape {
    associatedtype Unit: Numeric
    func area() -> Unit
}

struct Square: Shape {
    let side: Double
    func area() -> Double { side * side }
}

func makeShape() -> Shape {
    Square(side: 2)
}

// MARK: - 2.
func maximum<T>(_ items: [T]) -> T {
    var best = items[0]
    for item in items where item > best {
        best = item
    }
    return best
}

// MARK: - 3.
protocol Animal {
    func sound() -> String
}

extension Animal {
    func sound() -> String { "..." }
}

class Dog: Animal {
    func sound() -> String { "Woof" }
}

class Puppy: Dog {
    override func sound() -> String { "Yip" }
}

func makeNoise(_ animals: [Animal]) -> [String] {
    animals.map { $0.sound() }
}

// MARK: - 4.
func printAllAreas(_ shapes: [any Shape]) {
    for shape in shapes {
        print(shape)
    }
}

//: [Suivant](@next)
