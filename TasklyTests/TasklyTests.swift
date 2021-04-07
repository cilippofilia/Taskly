//
//  TasklyTests.swift
//  TasklyTests
//
//  Created by Filippo Cilia on 06/04/2021.
//

import CoreData
import XCTest
@testable import Taskly

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
