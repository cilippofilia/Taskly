//
//  AwardTests.swift
//  TasklyTests
//
//  Created by Filippo Cilia on 07/04/2021.
//

import CoreData
import XCTest
@testable import Taskly

class AwardTests: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    func testNewUserHasNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have earned no awards.")
        }
    }

    func testAddingTasks() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {

            for _ in 0 ..< value {
                _ = Task(context: managedObjectContext)
            }

            let matches = awards.filter { award in
                award.criterion == "items" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Adding \(value) tasks should unlock \(count + 1) awards.")
        }

        dataController.deleteAll()
    }

    func testCompletingTasks() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]

        for (count, value) in values.enumerated() {

            for _ in 0 ..< value {
                let task = Task(context: managedObjectContext)
                task.completed = true
            }

            let matches = awards.filter { award in
                award.criterion == "complete" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Completing \(value) tasks should unlock \(count + 1) awards.")

            dataController.deleteAll()
        }
    }
}
