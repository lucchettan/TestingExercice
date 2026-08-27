//
//  User.swift
//  RefactoringExercise
//
//  Created by Nicolas Lucchetta on 27/08/2026.
//

import Foundation

struct User: Decodable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let age: Int
    let country: String

    var isVIP: Bool {
        age > 60 || country == "FR"
    }
}
