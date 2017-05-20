//
//  ConstraintTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class ConstraintTests: XCTestCase {

    fileprivate let testInput = "testInput"
    fileprivate let predicate = MockPredicate(testInput: "testInput")

    var constraint:Constraint<String>!

    override func setUp() {
        super.setUp()
        constraint = Constraint(predicate: predicate, error: TestError.InvalidInput)
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

extension ConstraintTests {
    
    func testThatItDynamicallyBuildsTheValidationError() {
        
        let constraint = Constraint(predicate: predicate) { TestError.UnexpectedInput($0) }
        let result = constraint.evaluate(with: "Ok")
        switch result {
        case .invalid(let error as TestError):
            XCTAssertEqual(TestError.UnexpectedInput("Ok"), error)
        default:
            XCTFail()
        }
    }
}

// MARK: - Test Error

fileprivate enum TestError: Error {
    case InvalidInput
    case UnexpectedInput(String)
}

extension TestError: Equatable {
    
    public static func ==(lhs: TestError, rhs: TestError) -> Bool {
        return (lhs.localizedDescription == rhs.localizedDescription)
    }
}

// MARK: - Mock Predicate

fileprivate struct MockPredicate: Predicate  {

    var testInput: String
    
    func evaluate(with input: String) -> Bool {
        return input == testInput
    }
}
