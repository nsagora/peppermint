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

    fileprivate let testInput = "testInput"
    fileprivate let predicate = MockPredicate(testInput: "testInput")
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
    
    func testThatAfterInitItHasNoConstraints() {
        XCTAssertEqual(constraintSet.constraints.count, 0)
    }
    
    func testThatItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        let constraintSet = ConstraintSet<String>(constraints:[])
        XCTAssertEqual(constraintSet.constraints.count, 0)
    }
    
    func testThatItCanBeInstantiatedWithAnArrayofConstrains() {
        
        let predicate = MockPredicate(testInput: testInput)
        let constraint = Constraint(predicate: predicate, error:TestError.InvalidInput)
        
        let constraintSet = ConstraintSet<String>(constraints:[constraint])
        XCTAssertEqual(constraintSet.constraints.count, 1)
    }
    
    func testThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {
        
        let predicate = MockPredicate(testInput: testInput)
        let constraint = Constraint(predicate: predicate, error:TestError.InvalidInput)
        
        let constraintSet = ConstraintSet<String>(constraints:constraint)
        XCTAssertEqual(constraintSet.constraints.count, 1)
    }
}

extension ConstraintSetTests {
    
    func testThatCanAddConstraint() {
        
        let constraint = Constraint(predicate: predicate, error:TestError.InvalidInput)
        
        constraintSet.add(constraint: constraint)
        XCTAssertEqual(constraintSet.constraints.count, 1)
    }
    
    func testThatCanAddConstraintAlternativeOne() {
        
        constraintSet.add(predicate: predicate, error:TestError.InvalidInput)
        XCTAssertEqual(constraintSet.constraints.count, 1)
    }
}

extension ConstraintSetTests {
    
    func testThatItValidatesAnyToValid() {
        
        constraintSet.add(predicate: predicate, error:TestError.InvalidInput)
     
        switch constraintSet.evaluateAny(input: testInput) {
        case .valid:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func testThatItValidatesAnyToInvalid() {
        
        constraintSet.add(predicate: predicate, error:TestError.InvalidInput)
        
        switch constraintSet.evaluateAny(input: "") {
        case .invalid:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func testThatItValidatesAll() {
        
        constraintSet.add(predicate: predicate, error:TestError.InvalidInput)
        constraintSet.add(predicate: predicate, error:TestError.MissingInput)
        
        let result = constraintSet.evaluateAll(input: testInput)
        XCTAssertEqual(result.count, 2)
    }
}

// MARK: - Test Error

fileprivate enum TestError: Error {
    case InvalidInput
    case MissingInput
}

// MARK: - Mock Predicate

fileprivate struct MockPredicate: Predicate  {
    
    var testInput: String
    
    func evaluate(with input: String) -> Bool {
        return input == testInput
    }
}
