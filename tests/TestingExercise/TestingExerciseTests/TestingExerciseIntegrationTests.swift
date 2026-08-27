import XCTest
@testable import TestingExercise

final class TestingExerciseIntegrationTests: XCTestCase {

    /// Vérifie la vraie persistance : une tâche ajoutée par une instance du repository
    /// est relue par une autre instance branchée sur le même store.
    func testAddPersistsTaskAcrossRepositoryInstances() {
        let store = InMemoryStore()
        TasksRepository(store: store).add(title: "Tâche A")
        let reloaded = TasksRepository(store: store).load()
        XCTAssertEqual(reloaded.map(\.title), ["Tâche A"])
    }

    /// Vérifie le cumul : deux ajouts successifs donnent deux tâches.
    func testCountIsTwoAfterTwoAdds() {
        let repo = TasksRepository(store: InMemoryStore())
        repo.add(title: "Tâche A")
        let result = repo.add(title: "Tâche B")
        XCTAssertEqual(result.count, 2)
    }

    /// Vérifie le flow complet à travers les couches : une tâche ajoutée via un premier ViewModel est retrouvée par un second ViewModel pour simuler un 'relaunch de l'app'.
    @MainActor
    func testTaskAddedThroughViewModelSurvivesRelaunch() {
        let store = InMemoryStore()

        let firstLaunch = TasksViewModel(repository: TasksRepository(store: store))
        firstLaunch.newTitle = "Tâche C"
        firstLaunch.add()

        let secondLaunch = TasksViewModel(repository: TasksRepository(store: store))
        secondLaunch.onAppear()

        XCTAssertEqual(secondLaunch.items.map(\.title), ["Tâche C"])
    }
}
