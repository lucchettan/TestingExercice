//
//  UsersFeature.swift
//  RefactoringExercise
//
//  Created by Nicolas Lucchetta on 27/08/2026.
//

import SwiftUI

@MainActor
struct UsersView: View {
    @StateObject private var viewModel: UsersViewModel
    
    init(viewModel: UsersViewModel = UsersViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
            case .loaded(let users):
                List(users) { user in
                    HStack {
                        if user.isVIP {
                            Text("⭐️")
                        }
                        Text("\(user.name) (\(user.age))")
                    }
                }
            case .failed(let message):
                ContentUnavailableView {
                    Label("Erreur", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                } actions: {
                    Button("Réessayer") {
                        Task { await viewModel.fetch() }
                    }
                }
            }
        }
        .task {
            await viewModel.fetch()
        }
    }
}
