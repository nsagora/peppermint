//
//  ValidatorTests.swift
//  ValidationKit
//
//  Created by Alex Cristea on 17/09/2016.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationKit

class ValidatorTests: XCTestCase {

    var validator: Validator<String>!
    
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
        
        let predicate = MockValidatorPredicate()
        let constraint = ValidationConstraint(predicate: predicate, message: "Input should be nil")
        
        let validator = Validator<String>(constraints:[constraint])
        XCTAssertEqual(validator.constraints.count, 1)
    }
    
    func testThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {
        
        let predicate = MockValidatorPredicate()
        let constraint = ValidationConstraint(predicate: predicate, message: "Input should be nil")
        
        let validator = Validator<String>(constraints:constraint)
        XCTAssertEqual(validator.constraints.count, 1)
    }
}

extension ValidatorTests {
    
    func testThatCanAddValidationConstraint() {
        
        let predicate = MockValidatorPredicate()
        let constraint = ValidationConstraint(predicate: predicate, message: "Input should be nil")
        
        validator.add(constraint: constraint)
        XCTAssertEqual(validator.constraints.count, 1)
    }
    
    func testThatCanAddValidationConstraintAlternativeOne() {
        
        let predicate = MockValidatorPredicate()
        validator.add(predicate: predicate, message: "Input should be nil")
        XCTAssertEqual(validator.constraints.count, 1)
    }
    
    func testThatCanAddValidationConstraintAlternativeTwo() {
        
        let predicate = MockValidatorPredicate()
        validator.add(predicate: predicate, message: { return "\($0) should be nil" })
        XCTAssertEqual(validator.constraints.count, 1)
    }
}

extension ValidatorTests {
    
    func testThatItValidatesAnyToValid() {
        let predicate = MockValidatorPredicate()
        validator.add(predicate: predicate, message: "Input should be nil")
     
        switch validator.evaluateAny(input: nil) {
        case .valid:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func testThatItValidatesAnyToInvalid() {
        let predicate = MockValidatorPredicate()
        validator.add(predicate: predicate, message: "Input should be nil")
        
        switch validator.evaluateAny(input: "") {
        case .invalid:
            XCTAssert(true)
        default:
            XCTFail()
        }
    }
    
    func testThatItValidatesAll() {
        let predicate = MockValidatorPredicate()
        validator.add(predicate: predicate, message: "Input should be nil")
        validator.add(predicate: predicate, message: "Input should be nil twice")
        
        let result = validator.evaluateAll(input: nil)
        XCTAssertEqual(result.count, 2)
    }
}

extension ValidatorTests {
    
    static var allTests : [(String, (ValidatorTests) -> () throws -> Void)] {
        return [
            ("testThatItCanBeInstantiated", testThatItCanBeInstantiated),
            ("testThatAfterInitItHasNoConstraints", testThatAfterInitItHasNoConstraints),
            ("testThatCanAddValidationConstraint", testThatCanAddValidationConstraint),
            ("testThatCanAddValidationConstraintAlternativeOne", testThatCanAddValidationConstraintAlternativeOne),
            ("testThatCanAddValidationConstraintAlternativeTwo", testThatCanAddValidationConstraintAlternativeTwo),
        ]
    }
}

fileprivate struct MockValidatorPredicate: ValidationPredicate  {
    
    func evaluate(with input: String?) -> Bool {
        return input == nil
    }
}
