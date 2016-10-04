//
//  ValidationResultTests.swift
//  ValidationKit
//
//  Created by Alex Cristea on 17/09/2016.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationKit

class ValidationResultTests: XCTestCase {

    func testIsValid() {
        XCTAssertTrue(ValidationResult.Valid.isValid)
        XCTAssertFalse(ValidationResult.Valid.isInvalid)
    }
    
    func testIsInvalid() {
        
        let error = ValidationError(message: "Invalid")
        
        XCTAssertTrue(ValidationResult.Invalid(error).isInvalid)
        XCTAssertFalse(ValidationResult.Invalid(error).isValid)
    }
}
