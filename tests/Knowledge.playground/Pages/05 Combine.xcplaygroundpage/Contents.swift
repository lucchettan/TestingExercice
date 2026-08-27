//: [Précédent](@previous)
/*:
 # 05 — Combine

 Operators, cancellables, threading, cycles de rétention.

 Attendus utiles :
 - **Exercice 3** — `combined(_:_:)` doit émettre, à chaque nouvelle valeur de
   `a` **ou** `b`, le **couple** `(dernière valeur de a, dernière valeur de b)`.
 - **Exercice 4** — la closure de `observe(_:)` est censée réaliser une
   **mise à jour d'interface**.
 */
import Foundation
import Combine

// MARK: - 1.
final class SearchService {
    let subject = PassthroughSubject<String, Never>()

    func start() {
        _ = subject
            .map { $0.uppercased() }
            .sink { print($0) }
    }
}

// MARK: - 2.
final class ProfileViewModel {
    var name = ""
    var cancellables = Set<AnyCancellable>()
    let namePublisher = PassthroughSubject<String, Never>()

    func bind() {
        namePublisher
            .sink { value in
                self.name = value
            }
            .store(in: &cancellables)
    }
}

// MARK: - 3.
func combined(_ a: AnyPublisher<Int, Never>,
              _ b: AnyPublisher<Int, Never>) -> AnyPublisher<(Int, Int), Never> {
    Publishers.Zip(a, b).eraseToAnyPublisher()
}

// MARK: - 4.
func observe(_ publisher: AnyPublisher<Int, Never>) -> AnyCancellable {
    publisher
        .subscribe(on: DispatchQueue.global())
        .sink { value in
            print("UI update \(value)")
        }
}

//: [Suivant](@next)
