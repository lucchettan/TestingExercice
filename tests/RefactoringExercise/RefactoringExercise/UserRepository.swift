//
//  UserRepository.swift
//  RefactoringExercise
//
//  Created by Nicolas Lucchetta on 27/08/2026.
//

import Foundation

 protocol UserRepository {
     func fetchUsers() async throws -> [User]
 }

 struct RemoteUserRepository: UserRepository {
     private let session: URLSession
     private let url: URL

     init(session: URLSession = .shared,
          url: URL = URL(string: "https://api.example.com/users")!) {
         self.session = session
         self.url = url
     }

     func fetchUsers() async throws -> [User] {
         let (data, response) = try await session.data(from: url)
         guard let http = response as? HTTPURLResponse,
               (200..<300).contains(http.statusCode) else {
             throw URLError(.badServerResponse)
         }
         return try JSONDecoder().decode([User].self, from: data)
     }
 }
