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
        case .invalid(let summary):
            XCTAssertEqual([FakeError.Invalid], summary.errors as! [FakeError])
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
        let expectedResult = Result.Summary(errors: [FakeError.Invalid])
        XCTAssertEqual(result, Result.invalid(expectedResult))
    }
    
    func testThatItEvaluateWhenHavingAValidCondition() {
        
        let p = FakePredicate(expected: "001")
        let condition = Constraint(predicate: p, error: FakeError.Invalid)
        
        constraint.add(condition:condition)
        
        let result = constraint.evaluate(with: "001")
        let summary = Result.Summary(errors: [FakeError.Invalid])
        XCTAssertEqual(result, Result.invalid(summary))
    }
    
    func testThatItEvaluateWhenHavingMultiLevelCondition() {
        
        let p_1 = FakePredicate(expected: "001")
        var condition_1 = Constraint(predicate: p_1, error: FakeError.Unexpected("Expecting 001"))
        
        let p_2 = FakePredicate(expected: "002")
        let condition_2 = Constraint(predicate: p_2, error: FakeError.Unexpected("Expecting 002"))
        
        let p_3 = FakePredicate(expected: "003")
        let condition_3 = Constraint(predicate: p_3, error: FakeError.Unexpected("Expecting 003"))
        
        condition_1.add(condition:condition_2)
        condition_1.add(condition:condition_3)
        constraint.add(condition:condition_1)
        
        var result = constraint.evaluate(with: "001")
        var summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
        XCTAssertEqual(result, Result.invalid(summary))
        
        result = constraint.evaluate(with: "004")
        summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
        XCTAssertEqual(result, Result.invalid(summary))
    }
}

extension ConstraintTests {
    
    func testThatItDynamicallyBuildsTheValidationError() {
        
        let constraint = Constraint(predicate: fakePredicate) { FakeError.Unexpected($0) }
        let result = constraint.evaluate(with: "Ok")
        switch result {
        case .invalid(let summary):
            XCTAssertEqual([FakeError.Unexpected("Ok")], summary.errors as! [FakeError])
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
