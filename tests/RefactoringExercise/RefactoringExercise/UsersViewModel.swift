//
//  UsersViewModel.swift
//  RefactoringExercise
//
//  Created by Nicolas Lucchetta on 27/08/2026.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
    /// Les 4 états possibles de l'écran.
    /// Un seul état à la fois: la view ne peut jamais afficher un chargement et une erreur en même temps.
    enum State: Equatable {
        case idle
        case loading
        case loaded([User])
        case failed(String)
    }

    @Published private(set) var state: State = .idle

    private let repository: UserRepository
    
    nonisolated init(repository: UserRepository = RemoteUserRepository()) {
        self.repository = repository
    }
    
    /// Charge les utilisateurs et met à jour l'état de l'écran.
    func fetch() async {
        state = .loading
        do {
            state = .loaded(try await repository.fetchUsers())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
