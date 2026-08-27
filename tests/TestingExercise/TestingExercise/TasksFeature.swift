import Foundation
import SwiftUI

// MARK: - Modèle

struct TodoItem: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var isDone: Bool

    init(id: UUID = UUID(), title: String, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}

// MARK: - Provider (lecture / écriture dans UserDefaults)

/// Petite abstraction clé/valeur pour pouvoir injecter un stockage en mémoire dans les tests.
protocol KeyValueStore {
    func data(forKey key: String) -> Data?
    func set(_ data: Data?, forKey key: String)
}

/// Implémentation concrète basée sur `UserDefaults`.
final class UserDefaultsProvider: KeyValueStore {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func data(forKey key: String) -> Data? {
        defaults.data(forKey: key)
    }

    func set(_ data: Data?, forKey key: String) {
        defaults.set(data, forKey: key)
    }
}

// MARK: - Repository

protocol TasksRepositoryProtocol {
    func load() -> [TodoItem]
    func save(_ items: [TodoItem])
    @discardableResult func add(title: String) -> [TodoItem]
    @discardableResult func toggle(id: UUID) -> [TodoItem]
}

/// Contient la logique métier de persistance :
/// - encodage / décodage JSON
/// - validation du titre (trim, rejet du vide)
/// - déduplication insensible à la casse
final class TasksRepository: TasksRepositoryProtocol {
    private let store: KeyValueStore
    private let key = "tasks"

    init(store: KeyValueStore = UserDefaultsProvider()) {
        self.store = store
    }

    func load() -> [TodoItem] {
        guard let data = store.data(forKey: key),
              let items = try? JSONDecoder().decode([TodoItem].self, from: data) else {
            return []
        }
        return items
    }

    func save(_ items: [TodoItem]) {
        let data = try? JSONEncoder().encode(items)
        store.set(data, forKey: key)
    }

    @discardableResult
    func add(title: String) -> [TodoItem] {
        var items = load()
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return items }
        guard !items.contains(where: { $0.title.lowercased() == trimmed.lowercased() }) else {
            return items
        }
        items.append(TodoItem(title: trimmed))
        save(items)
        return items
    }

    @discardableResult
    func toggle(id: UUID) -> [TodoItem] {
        var items = load()
        if let index = items.firstIndex(where: { $0.id == id }) {
            items[index].isDone.toggle()
            save(items)
        }
        return items
    }
}

// MARK: - ViewModel

@MainActor
@Observable
final class TasksViewModel {
    private(set) var items: [TodoItem] = []
    var newTitle: String = ""

    @ObservationIgnored private let repository: TasksRepositoryProtocol

    init(repository: TasksRepositoryProtocol = TasksRepository()) {
        self.repository = repository
    }

    var remainingCount: Int {
        items.filter { !$0.isDone }.count
    }

    func onAppear() {
        items = repository.load()
    }

    func add() {
        items = repository.add(title: newTitle)
        newTitle = ""
    }

    func toggle(_ item: TodoItem) {
        items = repository.toggle(id: item.id)
    }
}

// MARK: - Vue

struct TasksView: View {
    @State private var vm = TasksViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("Nouvelle tâche", text: $vm.newTitle)
                        Button("Ajouter") { vm.add() }
                            .disabled(vm.newTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                Section("Tâches (\(vm.remainingCount) restantes)") {
                    ForEach(vm.items) { item in
                        Button {
                            vm.toggle(item)
                        } label: {
                            HStack {
                                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                                Text(item.title)
                                    .strikethrough(item.isDone)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tâches")
            .onAppear { vm.onAppear() }
        }
    }
}
