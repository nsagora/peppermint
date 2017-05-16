//
//  ValidatorTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 17/09/2016.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class ValidatorTests: XCTestCase {

    fileprivate let testInput = "testInput"
    fileprivate let predicate = MockValidatorPredicate(testInput: "testInput")
    fileprivate var validator: Validator<String>!
    
    override func setUp() {
        super.setUp()
        validator = Validator()
    }
    
    override func tearDown() {
        validator = nil
        super.tearDown()
    }
}

extension ValidatorTests {
    
    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(validator)
    }
    
    func testThatAfterInitItHasNoConstraints() {
        XCTAssertEqual(validator.constraints.count, 0)
    }
    
    func testThatItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        let validator = Validator<String>(constraints:[])
        XCTAssertEqual(validator.constraints.count, 0)
    }
    
    func testThatItCanBeInstantiatedWithAnArrayofConstrains() {
        
        let predicate = MockValidatorPredicate(testInput: testInput)
        let constraint = ValidationConstraint(predicate: predicate, message: "Input should be equal to testInput")
        
        let validator = Validator<String>(constraints:[constraint])
        XCTAssertEqual(validator.constraints.count, 1)
    }
    
    func testThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {
        
        let predicate = MockValidatorPredicate(testInput: testInput)
        let constraint = ValidationConstraint(predicate: predicate, message: "Input should be equal to testInput")
        
        let validator = Validator<String>(constraints:constraint)
        XCTAssertEqual(validator.constraints.count, 1)
    }
}

extension ValidatorTests {
    
    func testThatCanAddValidationConstraint() {
        
        let constraint = ValidationConstraint(predicate: predicate, message: "Input should be equal to testInput")
        
        validator.add(constraint: constraint)
        XCTAssertEqual(validator.constraints.count, 1)
    }
    
    func testThatCanAddValidationConstraintAlternativeOne() {
        
        validator.add(predicate: predicate, message: "Input should be equal to testInput")
        XCTAssertEqual(validator.constraints.count, 1)
    }
    
    func testThatCanAddValidationConstraintAlternativeTwo() {
        
        validator.add(predicate: predicate, message: { return "\($0) should be equal to testInput" })
        XCTAssertEqual(validator.constraints.count, 1)
    }
}

extension ValidatorTests {
    
    func testThatItValidatesAnyToValid() {
        
        validator.add(predicate: predicate, message: "Input should be equal to testInput")
     
        switch validator.evaluateAny(input: testInput) {
        case .valid:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func testThatItValidatesAnyToInvalid() {
        
        validator.add(predicate: predicate, message: "Input should be equal to testInput")
        
        switch validator.evaluateAny(input: "") {
        case .invalid:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func testThatItValidatesAll() {
        
        validator.add(predicate: predicate, message: "Input should be equal to testInput")
        validator.add(predicate: predicate, message: "Input should be equal to testInput twice")
        
        let result = validator.evaluateAll(input: testInput)
        XCTAssertEqual(result.count, 2)
    }
}

fileprivate struct MockValidatorPredicate: ValidationPredicate  {
    
    var testInput: String
    
    func evaluate(with input: String) -> Bool {
        return input == testInput
    }
}
