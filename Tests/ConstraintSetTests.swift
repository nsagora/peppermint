//
//  ConstraintSetTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 17/09/2016.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class ConstraintSetTests: XCTestCase {

    fileprivate let validFakeInput = "fakeInput"
    fileprivate let invalidFakeInput = "~fakeInput"
    fileprivate let predicate = MockPredicate(testInput: "fakeInput")
    fileprivate var constraintSet: ConstraintSet<String>!
    
    override func setUp() {
        super.setUp()
        constraintSet = ConstraintSet()
    }
    
    override func tearDown() {
        constraintSet = nil
        super.tearDown()
    }
}

extension ConstraintSetTests {
    
    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(constraintSet)
    }
    
    func testThatAfterInit_ItHasNoConstraints() {
        XCTAssertEqual(constraintSet.count, 0)
    }
    
    func testThatItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        
        let constraints = [AnyConstraint<String>]()
        let constraintSet = ConstraintSet<String>(constraints:constraints)
        XCTAssertEqual(constraintSet.count, 0)
    }

    func testThatItCanBeInstantiatedWithAnFinitArrayofConstrains() {

        let predicate = MockPredicate(testInput: validFakeInput)
        let constraint = Constraint(predicate: predicate, error:FakeError.InvalidInput)

        let constraintSet = ConstraintSet<String>(constraints:[constraint])
        XCTAssertEqual(constraintSet.count, 1)
    }

    func testThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {

        let predicate = MockPredicate(testInput: validFakeInput)
        let constraint = Constraint(predicate: predicate, error:FakeError.InvalidInput)

        let constraintSet = ConstraintSet<String>(constraints:constraint)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testThatWithoutConstraints_EvaluateAny_IsValid() {
        
        let result = constraintSet.evaluateAny(input: "any")
        switch result {
        case .valid:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }
    
    func testThatWithoutConstraints_EvaluateAll_IsValid() {
        
        let result = constraintSet.evaluateAny(input: "all")
        switch result {
        case .valid:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }
}

extension ConstraintSetTests {
    
    func testThatCanAddConstraint() {
        
        let constraint = Constraint(predicate: predicate, error:FakeError.InvalidInput)
        
        constraintSet.add(constraint: constraint)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testThatCanAddConstraintUsingAlternativeMethod() {
        
        constraintSet.add(predicate: predicate, error:FakeError.InvalidInput)
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension ConstraintSetTests {
    
    func testThatForValidInput_EvaluateAny_IsValid() {
        
        constraintSet.add(predicate: predicate, error:FakeError.InvalidInput)
     
        switch constraintSet.evaluateAny(input: validFakeInput) {
        case .valid:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func testThatForInvalidInput_EvaluateAny_IsInvalid() {
        
        constraintSet.add(predicate: predicate, error:FakeError.InvalidInput)
        
        let result = constraintSet.evaluateAny(input: invalidFakeInput)
        let summary = Result.Summary(errors: [FakeError.InvalidInput])
        
        XCTAssertEqual(result, Result.invalid(summary))
    }
    
    func testThatForValidInput_EvaluateAll_IsValid() {
        
        constraintSet.add(predicate: predicate, error:FakeError.InvalidInput)
        constraintSet.add(predicate: predicate, error:FakeError.MissingInput)
        
        let result = constraintSet.evaluateAll(input: validFakeInput)
        XCTAssertEqual(result, Result.valid)
    }

    func testThatForInvalidInput_EvaluateAll_IsInvalid() {

        constraintSet.add(predicate: predicate, error:FakeError.InvalidInput)
        constraintSet.add(predicate: predicate, error:FakeError.MissingInput)

        let result = constraintSet.evaluateAll(input: invalidFakeInput)
        let summary = Result.Summary(errors: [FakeError.InvalidInput, FakeError.MissingInput])
        XCTAssertEqual(result, Result.invalid(summary))
    }
}

// MARK: - Test Error

fileprivate enum FakeError: FakeableError {
    case InvalidInput
    case MissingInput
    case FailingCondition
}

// MARK: - Mock Predicate

fileprivate struct MockPredicate: Predicate  {
    
    var testInput: String
    
    func evaluate(with input: String) -> Bool {
        return input == testInput
    }
}
