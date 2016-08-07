//
//  RegexValidationRuleTests.swift
//  Validator
//
//  Created by Alex Cristea on 05/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import XCTest
@testable import Validator

class RegexValidationRuleTests: XCTestCase {

    var rule: RegexValidationRule!

    override func setUp() {
        super.setUp()
        rule = RegexValidationRule(expression: "^[0-9]$")
    }
    
    override func tearDown() {
        rule = nil
        super.tearDown()
    }

    func testItCanBeInstantiated() {
        XCTAssertNotNil(rule)
    }

    func testItFailsValidationForNil() {
        let result = rule.validate(input: nil)
        XCTAssertFalse(result)
    }

    func testItFailsValidationForInvalidInput() {
        let result = rule.validate(input: "a")
        XCTAssertFalse(result)
    }

    func testItFailsValidationForLongInvalidInput() {
        let result = rule.validate(input: "1111111111")
        XCTAssertFalse(result)
    }

    func testItPassValidationForValidInput() {
        let result = rule.validate(input: "1")
        XCTAssertTrue(result)
    }

    func testItPassValitdationWithUTF8() {
        let rule = RegexValidationRule(expression: "^\\p{L}$")
        let result = rule.validate(input: "é")
        XCTAssertTrue(result)
    }

    func testItPassValitdationWithUTF16() {
        let rule = RegexValidationRule(expression: "^\\p{L}$")
        let result = rule.validate(input: "ߘ")
        XCTAssertTrue(result)
    }
}
