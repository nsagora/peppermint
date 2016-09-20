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

    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(validator)
    }
    
    func testThatAfterInitItHasNoConstraints() {
        XCTAssertEqual(validator.constraints.count, 0)
    }
    
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

fileprivate struct MockValidatorPredicate: ValidationPredicate  {
    
    func evaluate(with input: String?) -> Bool {
        return input == nil
    }
}
