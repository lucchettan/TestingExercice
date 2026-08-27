import XCTest
@testable import TestingExercise

final class TestingExerciseIntegrationTests: XCTestCase {

    func test1_addPersistsTask() {
        let repo = TasksRepository()
        let result = repo.add(title: "Tâche A")
        XCTAssertTrue(result.contains { $0.title == "Tâche A" })
    }

    func test2_countIsTwoAfterSecondAdd() {
        let repo = TasksRepository()
        let result = repo.add(title: "Tâche B")
        XCTAssertEqual(result.count, 2)
    }

    @MainActor
    func testFullFlowThroughViewModel() {
        let vm = TasksViewModel()
        vm.newTitle = "Tâche C"
        vm.add()
        vm.onAppear()
        XCTAssertGreaterThan(vm.items.count, 0)
    }
}
