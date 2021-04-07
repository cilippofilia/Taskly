//
//  ProjectTests.swift
//  TasklyTests
//
//  Created by Filippo Cilia on 07/04/2021.
//

import CoreData
import XCTest
@testable import Taskly

class ProjectTests: BaseTestCase {
    func testCreatingProjectsAndTasks() {
        let targetCount = 10

        for _ in 0 ..< targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0 ..< targetCount {
                let task = Task(context: managedObjectContext)
                task.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Task.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectCascadeDeletesTasks() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)

        dataController.delete(projects[0])

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Task.fetchRequest()), 40)
    }
}
