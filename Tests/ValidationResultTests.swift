//
//  ValidationResultTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 17/09/2016.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class ValidationResultTests: XCTestCase {

    func testIsValid() {
        XCTAssertTrue(ValidationResult.valid.isValid)
        XCTAssertFalse(ValidationResult.valid.isInvalid)
    }
    
    func testIsInvalid() {
        
        let error = ValidationError(message: "Invalid")
        
        XCTAssertTrue(ValidationResult.invalid(error).isInvalid)
        XCTAssertFalse(ValidationResult.invalid(error).isValid)
    }
    
    func testResultError() {
        
        let error = ValidationError(message: "Invalid")
        
        XCTAssertTrue(ValidationResult.invalid(error).error != nil)
        XCTAssertTrue(ValidationResult.valid.error == nil)
    }
}
