//
//  PerformanceTests.swift
//  TasklyTests
//
//  Created by Filippo Cilia on 08/04/2021.
//

import XCTest
@testable import Taskly

class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformance() throws {
//        Create a significant amount of test data
        for _ in 1 ... 100 {
            try dataController.createSampleData()
        }

//        Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count,
                       500,
                       "This check the number of awards is constant. Change this if you add new awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
