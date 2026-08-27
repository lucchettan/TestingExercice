//: [Précédent](@previous)
/*:
 # 06 — Observation

 Écran SwiftUI ciblant les dernières API d'observation (framework `Observation`).

 Attendu utile :
 - **Exercice 3** — `DetailView` **reçoit** son modèle depuis sa vue parente
   (elle ne l'instancie pas elle-même).
 */
import Foundation
import Observation
import SwiftUI

// MARK: - 1.
final class CartViewModel: ObservableObject {
    @Published var items: [String] = []
    @Published var total: Double = 0
}

struct CartView: View {
    @StateObject var viewModel = CartViewModel()
    var body: some View {
        Text("\(viewModel.items.count)")
    }
}

// MARK: - 2.
@Observable
final class SettingsModel {
    @ObservationIgnored var username: String = ""
    @ObservationIgnored var analyticsSessionID: String = UUID().uuidString
    var isDarkMode: Bool = false

    func rename(to newName: String) {
        username = newName
    }
}

struct SettingsView: View {
    @State var model = SettingsModel()
    var body: some View {
        VStack {
            Text(model.username)
            Button("Renommer") { model.rename(to: "Alice") }
            Toggle("Dark", isOn: $model.isDarkMode)
        }
    }
}

// MARK: - 3.
struct DetailView: View {
    @State var model: SettingsModel
    var body: some View {
        Text(model.username)
    }
}

//: [Suivant](@next)
