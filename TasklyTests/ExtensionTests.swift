//
//  ExtensionTests.swift
//  TasklyTests
//
//  Created by Filippo Cilia on 07/04/2021.
//

import SwiftUI
import XCTest
@testable import Taskly

class ExtensionTests: XCTestCase {
    func testSequenceKeyPathSortingSelf() {
        let tasks = [1, 4, 3, 5, 2]
        let sortedTasks = tasks.sorted(by: \.self)

        XCTAssertEqual(sortedTasks, [1, 2, 3, 4, 5], "The sorted tasks must be ascending.")
    }

    func testSequenceKeyPathSortingCustom() {
        struct Example: Equatable {
            let value: String
        }

        let example1 = Example(value: "a")
        let example2 = Example(value: "b")
        let example3 = Example(value: "c")
        let array = [example1, example2, example3]

        let sortedExample = array.sorted(by: \.value) {
            $0 > $1
        }

        XCTAssertEqual(sortedExample, [example3, example2, example1], "Reverse sorting should yield c, b, a.")
    }

    func testBundleDecodingAwards() {
        let awards = Bundle.main.decode([Award].self, from: "Awards.json")

        XCTAssertFalse(awards.isEmpty, "JSON should decode to a non-empty array.")
    }

    func testDecodingString() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode(String.self, from: "DecodableString.json")

        XCTAssertEqual(
            data,
            "The rain in Spain falls mainly on the Spaniards.",
            "The string must match the content of DecodableString.json"
        )
    }

    func testDecodingDictionary() {
        let bundle = Bundle(for: ExtensionTests.self)
        let data = bundle.decode([String: Int].self, from: "DecodableDictionary.json")

        XCTAssertEqual(data.count, 3, "There should be 3 items decoded from DecodableDictionary.json")
        XCTAssertEqual(data["One"], 1, "The dictionary should contain String to Int values.")
    }

    func testBindingOnChange() {
        // Given
        var onChangeFunctionRun = false

        func exampleFunctionCall() {
            onChangeFunctionRun = true
        }

        var storedValue = ""

        let binding = Binding(
            get: { storedValue },
            set: { storedValue = $0 }
        )

        let changedBinding = binding.onChange(exampleFunctionCall)
        // When
        changedBinding.wrappedValue = "Test"

        // Then
        XCTAssertTrue(onChangeFunctionRun, "The onChange() function must be run when binding is changed.")
    }
}
