//
//  DevelopmentTests.swift
//  TasklyTests
//
//  Created by Filippo Cilia on 07/04/2021.
//

import CoreData
import XCTest
@testable import Taskly

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Task.fetchRequest()), 50, "There should be 50 sample tasks.")
    }

    func testDeleteAllClearsEverything() throws {
//        try dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "DeleteAll() should leave 0 projects.")
        XCTAssertEqual(dataController.count(for: Task.fetchRequest()), 0, "DeleteAll() should leave 0 tasks.")
    }

    func testExampleProjectIsClosed() {
        let project = Project.example

        XCTAssertTrue(project.closed, "The example project should be closed.")
    }

    func testExampleTaskIsHighPriority() {
        let task = Task.example

        XCTAssertEqual(task.priority, 3, "The example task should be high priority.")
    }
}
