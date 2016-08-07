//
//  EmailValidationRuleTests.swift
//  Validator
//
//  Created by Alex Cristea on 07/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import XCTest
@testable import Validator

class EmailValidationRuleTests: XCTestCase {

    var rule: EmailValidationRule!

    override func setUp() {
        super.setUp()
        rule = EmailValidationRule()
    }
    
    override func tearDown() {
        rule = nil
        super.tearDown()
    }

    func testThatItFailsForNil() {
        let result = rule.validate(input: nil)
        XCTAssertFalse(result)
    }

    func testThatItFailsForInvalidEmail() {
        let email = "test@"
        let result = rule.validate(input: email)
        XCTAssertFalse(result)
    }

    func testThatItPassesForValidEmail() {
        let email = "test@example.com"
        let result = rule.validate(input: email)
        XCTAssertTrue(result)
    }

    func testThatItPassesForUTF8() {
        let email = "tést@example.com"
        let result = rule.validate(input: email)
        XCTAssertTrue(result)
    }
}
