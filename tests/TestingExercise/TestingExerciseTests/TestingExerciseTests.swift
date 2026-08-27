import XCTest
@testable import TestingExercise

final class TestingExerciseTests: XCTestCase {

    func testAddInsertsTaskWithTitle() {
        let repo = TasksRepository()
        let result = repo.add(title: "Lait ")
        XCTAssertTrue(result.contains { $0.title == "Lait" })
    }

    func testAddedTaskIsNotDone() {
        let repo = TasksRepository()
        let result = repo.add(title: "Pain")
        XCTAssertEqual(result.first(where: { $0.title == "Pain" })?.isDone, false)
    }

    func testToggleMarksTaskAsDone() {
        let repo = TasksRepository()
        let items = repo.add(title: "Café")
        let id = items.first(where: { $0.title == "Café" })!.id
        let updated = repo.toggle(id: id)
        XCTAssertEqual(updated.first(where: { $0.id == id })?.isDone, true)
    }

    @MainActor
    func testViewModelAddAppendsTask() {
        let vm = TasksViewModel()
        vm.newTitle = "Acheter du beurre"
        vm.add()
        XCTAssertTrue(vm.items.contains { $0.title == "Acheter du beurre" })
    }
}
