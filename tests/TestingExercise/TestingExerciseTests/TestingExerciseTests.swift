import XCTest
@testable import TestingExercise

/// Stockage en mémoire pour isoler les tests :
/// chaque test repart d'un état vide, rien n'est écrit dans le vrai UserDefaults.
final class InMemoryStore: KeyValueStore {
    private var storage: [String: Data] = [:]
    func data(forKey key: String) -> Data? { storage[key] }
    func set(_ data: Data?, forKey key: String) { storage[key] = data }
}

final class TestingExerciseTests: XCTestCase {

    // MARK: - add : cas nominal

    /// Vérifie le cas nominal : ajouter un titre valide crée exactement une tâche avec ce titre.
    func testAddInsertsTask() {
        let repo = TasksRepository(store: InMemoryStore())
        let result = repo.add(title: "Lait")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.title, "Lait")
    }

    // MARK: - add : formatage et mésusages

    /// Vérifie que les espaces et retours à la ligne autour du titre sont supprimés avant insertion.
    func testAddTrimsWhitespace() {
        let repo = TasksRepository(store: InMemoryStore())
        let result = repo.add(title: "  Lait \n")
        XCTAssertEqual(result.first?.title, "Lait")
    }

    /// Vérifie qu'un titre vide ou composé uniquement d'espaces est rejeté (aucune tâche créée).
    func testAddRejectsEmptyTitle() {
        let repo = TasksRepository(store: InMemoryStore())
        let result = repo.add(title: "   ")
        XCTAssertTrue(result.isEmpty)
    }

    /// Vérifie qu'ajouter deux fois le même titre ne crée pas de doublon.
    func testAddRejectsDuplicate() {
        let repo = TasksRepository(store: InMemoryStore())
        repo.add(title: "Lait")
        let result = repo.add(title: "Lait")
        XCTAssertEqual(result.count, 1)
    }
    
    /// Vérifie qu'une tâche fraîchement créée n'est pas marquée comme terminée par défaut.
    func testAddedTaskIsNotDone() {
        let repo = TasksRepository(store: InMemoryStore())
        let result = repo.add(title: "Pain")
        XCTAssertEqual(result.first?.isDone, false)
    }
    
    /// Vérifie que la prévention de duplication s'applique après formatage :
    /// " lait " est reconnu comme un doublon de "Lait" et donc n'est pas ajouté.
     func testAddRejectsDuplicateAfterFormatting() {
         let repo = TasksRepository(store: InMemoryStore())
         repo.add(title: "Lait")
         let result = repo.add(title: "  lait ")
         XCTAssertEqual(result.count, 1)
         XCTAssertEqual(result.first?.title, "Lait")
     }

    // MARK: - toggle

    /// Vérifie qu'un toggle sur une tâche existante la marque comme terminée.
    func testToggleMarksTaskAsDone() {
        let repo = TasksRepository(store: InMemoryStore())
        let id = repo.add(title: "Café").first!.id
        let updated = repo.toggle(id: id)
        XCTAssertEqual(updated.first?.isDone, true)
    }

    /// Vérifie que le toggle est bidirectionnel : deux toggles ramènent la tâche à "non terminée".
    func testToggleTwiceMarksTaskAsNotDone() {
        let repo = TasksRepository(store: InMemoryStore())
        let id = repo.add(title: "Café").first!.id
        repo.toggle(id: id)
        let updated = repo.toggle(id: id)
        XCTAssertEqual(updated.first?.isDone, false)
    }

    /// Vérifie qu'un toggle avec un id inconnu ne modifie rien et ne fait pas planter.
    func testToggleWithUnknownIdChangesNothing() {
        let repo = TasksRepository(store: InMemoryStore())
        let before = repo.add(title: "Café")
        let after = repo.toggle(id: UUID())
        XCTAssertEqual(after, before)
    }

    // MARK: - ViewModel

    /// Vérifie que le ViewModel ajoute bien la tâche saisie à sa liste d'items.
    @MainActor
    func testViewModelAddAppendsTask() {
        let viewModel = TasksViewModel(repository: TasksRepository(store: InMemoryStore()))
        viewModel.newTitle = "Acheter du beurre"
        viewModel.add()
        XCTAssertTrue(viewModel.items.contains { $0.title == "Acheter du beurre" })
    }

    /// Vérifie que le champ de saisie est vidé après un ajout (comportement UX attendu).
    @MainActor
    func testViewModelAddClearsInputField() {
        let viewModel = TasksViewModel(repository: TasksRepository(store: InMemoryStore()))
        viewModel.newTitle = "Acheter du beurre"
        viewModel.add()
        XCTAssertEqual(viewModel.newTitle, "")
    }
    
    /// Vérifie que remainingCount ne compte que les tâches non terminées.
    @MainActor
    func testViewModelRemainingCountIgnoresDoneTasks() {
        let viewModel = TasksViewModel(repository: TasksRepository(store: InMemoryStore()))
        viewModel.newTitle = "Lait"
        viewModel.add()
        viewModel.newTitle = "Pain"
        viewModel.add()
        viewModel.toggle(viewModel.items.first!)
        XCTAssertEqual(viewModel.remainingCount, 1)
    }
}
