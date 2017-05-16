//
//  ValidationConstraintTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class ValidationConstraintTests: XCTestCase {

    private let testInput = "testInput"
    private let predicate = MockValidatorPredicate(testInput: "testInput")

    var constraint:ValidationConstraint<String>!

    override func setUp() {
        super.setUp()
        constraint = ValidationConstraint(predicate: predicate, error: TestError.InvalidInput)
    }
    
    override func tearDown() {
        constraint = nil
        super.tearDown()
    }
    
    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(constraint)
    }

    func testThatItReturnsSuccessForValidInput() {
        let result = constraint.evaluate(with: testInput)
        switch result {
        case .valid:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func testThatItFailsWithErrorForInvalidInput() {
        let result = constraint.evaluate(with: "Ok")
        switch result {
        case .invalid(let error as TestError):
            XCTAssertEqual(TestError.InvalidInput, error)
        default:
            XCTFail()
        }
    }
}

fileprivate enum TestError: Error {
    case InvalidInput
}

fileprivate struct MockValidatorPredicate: ValidationPredicate  {

    var testInput: String
    
    func evaluate(with input: String) -> Bool {
        return input == testInput
    }
}
