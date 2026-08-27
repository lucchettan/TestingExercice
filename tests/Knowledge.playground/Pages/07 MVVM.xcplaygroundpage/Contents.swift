//: [Précédent](@previous)
/*:
 # 07 — MVVM

 Séparation des responsabilités, binding, testabilité.
 */
import Foundation
import SwiftUI

struct Order {
    let items: [Double]
    let country: String
}

// MARK: - 1.
struct CheckoutView: View {
    let order = Order(items: [10, 20, 30], country: "FR")

    var body: some View {
        let subtotal = order.items.reduce(0, +)
        let vat = order.country == "FR" ? subtotal * 0.20 : 0
        let total = subtotal + vat
        return Text("Total: \(total) €")
    }
}

// MARK: - 2.
final class ProductsViewModel {
    var products: [String] = []

    func load() {
        let url = URL(string: "https://api.example.com/products")!
        let data = try? Data(contentsOf: url)
        if let data, let list = try? JSONDecoder().decode([String].self, from: data) {
            products = list
        }
    }
}

//: [Suivant](@next)
