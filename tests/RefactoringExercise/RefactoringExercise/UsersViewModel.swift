//
//  UsersViewModel.swift
//  RefactoringExercise
//
//  Created by Nicolas Lucchetta on 27/08/2026.
//

import Foundation

@MainActor
final class UsersViewModel: ObservableObject {
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
    
    func fetch() async {
        state = .loading
        do {
            state = .loaded(try await repository.fetchUsers())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
