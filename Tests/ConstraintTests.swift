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

    fileprivate let fakeInput = "testInput"
    fileprivate let fakePredicate = FakePredicate(expected: "testInput")

    var constraint:Constraint<String>!

    override func setUp() {
        super.setUp()
        constraint = Constraint(predicate: fakePredicate, error: FakeError.Invalid)
    }
    
    override func tearDown() {
        constraint = nil
        super.tearDown()
    }
    
    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(constraint)
    }

    func testThatItReturnsSuccessForValidInput() {
        let result = constraint.evaluate(with: fakeInput)
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
        case .invalid(let error as FakeError):
            XCTAssertEqual(FakeError.Invalid, error)
        default:
            XCTFail()
        }
    }
}

extension ConstraintTests {
    
    func testAddConditions() {
        
        let p = FakePredicate(expected: "001")
        let condition = Constraint(predicate: p, error: FakeError.Invalid)
        
        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 1)
        
        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 2)
    }
    
    func testThatItDoentEvaluateWhenHavingAFailingCondition() {
        
        let p = FakePredicate(expected: "001")
        let condition = Constraint(predicate: p, error: FakeError.Invalid)
        
        constraint.add(condition:condition)
        
        let result = constraint.evaluate(with: "002")
        let expectedResult = [EvaluationResult.invalid(FakeError.Invalid)]
        XCTAssertEqual(result, EvaluationResult.unevaluated(expectedResult))
    }
    
    func testThatItEvaluateWhenHavingAValidCondition() {
        
        let p = FakePredicate(expected: "001")
        let condition = Constraint(predicate: p, error: FakeError.Invalid)
        
        constraint.add(condition:condition)
        
        let result = constraint.evaluate(with: "001")
        XCTAssertEqual(result, EvaluationResult.invalid(FakeError.Invalid))
    }
}

extension ConstraintTests {
    
    func testThatItDynamicallyBuildsTheValidationError() {
        
        let constraint = Constraint(predicate: fakePredicate) { FakeError.Unexpected($0) }
        let result = constraint.evaluate(with: "Ok")
        switch result {
        case .invalid(let error as FakeError):
            XCTAssertEqual(FakeError.Unexpected("Ok"), error)
        default:
            XCTFail()
        }
    }
}

// MARK: - Fakes

extension ConstraintTests {
    
    fileprivate enum FakeError: FakeableError {
        case Invalid
        case Unexpected(String)
    }
    
    fileprivate struct FakePredicate: Predicate  {
        
        var expected: String
        
        func evaluate(with input: String) -> Bool {
            return input == expected
        }
    }
}
