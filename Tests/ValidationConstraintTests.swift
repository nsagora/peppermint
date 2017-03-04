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

    private let predicate = MockValidatorPredicate()
    private let message = "Input should be nil!"

    var constraint:ValidationConstraint<Any>!

    override func setUp() {
        super.setUp()
        constraint = ValidationConstraint(predicate: predicate, message: message)
    }
    
    override func tearDown() {
        constraint = nil
        super.tearDown()
    }
    
    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(constraint)
    }

    func testThatItReturnsSuccessForValidInput() {
        let result = constraint.evaluate(with: nil)
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
        case .invalid(let error):
            XCTAssertEqual(message, error.localizedDescription)
        default:
            XCTFail()
        }
    }
}

extension ValidationConstraintTests {

    func testThatItCallsTheMessageBlock() {

        let predicate = BlockValidationPredicate<String> { $0! == "input" }
        let constraint = ValidationConstraint<String>(predicate: predicate) { return "\($0!) is invalid!" }
        let result = constraint.evaluate(with: "output")

        switch result {
        case .invalid(let error):
            XCTAssertEqual("output is invalid!", error.localizedDescription)
        default:
            XCTFail()
        }
    }
}

fileprivate struct MockValidatorPredicate: ValidationPredicate  {

    func evaluate(with input: Any?) -> Bool {
        return input == nil
    }
}
