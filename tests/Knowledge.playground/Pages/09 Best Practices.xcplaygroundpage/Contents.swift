//: [Précédent](@previous)
/*:
 # 09 — Bonnes pratiques

 Immutabilité, force unwrap, SOLID, code mort.
 */
import Foundation

// MARK: - 1.
func greeting(for name: String) -> String {
    var prefix = "Bonjour"
    var unused = 42
    let message = prefix + ", " + name
    return message
}

// MARK: - 2.
func configValue(_ dict: [String: Any], key: String) -> String {
    return dict[key] as! String
}

// MARK: - 3.
final class UserManager {
    func register(_ name: String) {
        let user = name.trimmingCharacters(in: .whitespaces)
        saveToDatabase(user)
        sendWelcomeEmail(to: user)
        logAnalytics("user_registered")
    }

    func saveToDatabase(_ name: String) {
        print("INSERT INTO users (name) VALUES ('\(name)')")
    }

    func sendWelcomeEmail(to name: String) {
        print("SMTP → Bienvenue \(name)")
    }

    func logAnalytics(_ event: String) {
        print("analytics: \(event)")
    }

    func renderProfileHTML(_ name: String) -> String {
        "<b>\(name)</b>"
    }
}

// MARK: - 4.
func isEmpty(_ text: String?) -> Bool {
    return text == "" || text == nil
}

//: [Suivant](@next)
