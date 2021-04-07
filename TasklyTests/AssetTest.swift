//
//  AssetTest.swift
//  TasklyTests
//
//  Created by Filippo Cilia on 06/04/2021.
//

import XCTest
@testable import Taskly

class AssetTest: XCTestCase {
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color \(color) from asset catalog.")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
}
