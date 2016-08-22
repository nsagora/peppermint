//
//  ValidationConstraintTests.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationKit

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
        case .Success:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func testThatItFailsWithErrorForInvalidInput() {
        let result = constraint.evaluate(with: "Ok")
        switch result {
        case .Failure(let error):
            XCTAssertEqual(message, error.localizedDescription)
        default:
            XCTFail()
        }
    }
}

extension ValidationConstraintTests {

    func testThatItCallsTheMessageBlock() {

        let predicate = EmailValidationPredicate()
        let constraint = ValidationConstraint<String>(predicate: predicate) { return "\($0!) is invalid!" }
        let result = constraint.evaluate(with: "@me")

        switch result {
        case .Failure(let error):
            XCTAssertEqual("@me is invalid!", error.localizedDescription)
        default:
            XCTFail()
        }
    }
}

struct MockValidatorPredicate: ValidationPredicate  {

    func evaluate(with input: Any?) -> Bool {
        return input == nil
    }
}
