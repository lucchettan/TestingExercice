import Foundation
import SwiftUI

final class DataManager {
    static let shared = DataManager()

    var users: [[String: Any]] = []
    var lastError: String = ""

    func loadUsers(completion: @escaping ([[String: Any]]) -> Void) {
        let url = URL(string: "https://api.example.com/users")!
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
        self.users = json
        completion(json)
    }
}

final class UsersViewModel: ObservableObject {
    @Published var rows: [String] = []
    @Published var isLoading = false

    var onDone: (() -> Void)?

    func fetch() {
        isLoading = true
        DataManager.shared.loadUsers { users in
            for i in 0..<users.count {
                let u = users[i]
                let name = u["name"] as! String
                let age = u["age"] as! Int
                let country = u["country"] as! String
                var vip = false
                if age > 60 { vip = true }
                if country == "FR" { vip = true }
                let prefix = vip ? "⭐️ " : ""
                self.rows.append(prefix + name + " (" + String(age) + ")")
            }
            self.isLoading = false
            self.onDone?()
        }
    }

    func fetchAgain() {
        DataManager.shared.loadUsers { users in
            for i in 0..<users.count {
                let u = users[i]
                let name = u["name"] as! String
                let age = u["age"] as! Int
                let country = u["country"] as! String
                var vip = false
                if age > 60 { vip = true }
                if country == "FR" { vip = true }
                let prefix = vip ? "⭐️ " : ""
                self.rows.append(prefix + name + " (" + String(age) + ")")
            }
        }
    }
}

struct UsersView: View {
    @ObservedObject var vm = UsersViewModel()

    var body: some View {
        List(vm.rows, id: \.self) { row in
            Text(row)
        }
        .onAppear {
            vm.fetch()
        }
    }
}
