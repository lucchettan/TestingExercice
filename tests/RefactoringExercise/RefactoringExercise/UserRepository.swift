//
//  UserRepository.swift
//  RefactoringExercise
//
//  Created by Nicolas Lucchetta on 27/08/2026.
//

import Foundation

protocol UserRepository: Sendable {
     func fetchUsers() async throws -> [User]
 }

struct RemoteUserRepository: UserRepository {
    private let session: URLSession
    private let url: URL
    
    init(session: URLSession = .shared, url: URL = URL(string: "https://api.example.com/users")!) {
        self.session = session
        self.url = url
    }
    
    /// L'ancien code utilisait Data(contentsOf:) : l'app restait figée  pendant le téléchargement, et le moindre problème faisait crasher.
    /// Ici l'appel est asynchrone, on vérifie que le serveur  répond,
    /// et si quelque chose se passe mal on renvoie une erreur que l'on peut gérer (afficher un message, proposer de réessayer).
    func fetchUsers() async throws -> [User] {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([User].self, from: data)
    }
}
