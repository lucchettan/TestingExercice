//: [Précédent](@previous)
/*:
 # 08 — Clean Architecture

 Couches, use cases, inversion de dépendance, direction des dépendances.
 */
import Foundation

// MARK: - DOMAIN
struct User: Decodable {
    let id: Int
    let name: String
}

final class GetUserUseCase {
    let repository = UserRepositoryImpl()

    func execute(id: Int) -> User? {
        repository.fetch(id: id)
    }
}

// MARK: - DATA
final class UserRepositoryImpl {
    func fetch(id: Int) -> User? {
        User(id: id, name: "Alice")
    }
}

// MARK: - PRESENTATION
final class UserPresenter {
    func present(id: Int) {
        let useCase = GetUserUseCase()
        if let user = useCase.execute(id: id) {
            print(user.name)
        }
    }
}

//: [Suivant](@next)
