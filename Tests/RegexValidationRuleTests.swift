//
//  RegexValidationPredicateTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 05/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class RegexValidationPredicateTests: XCTestCase {

    var rule: RegexValidationPredicate!

    override func setUp() {
        super.setUp()
        rule = RegexValidationPredicate(expression: "^[0-9]$")
    }
    
    override func tearDown() {
        rule = nil
        super.tearDown()
    }

    func testItCanBeInstantiated() {
        XCTAssertNotNil(rule)
    }

    func testItFailsValidationForNil() {
        let result = rule.evaluate(with: nil)
        XCTAssertFalse(result)
    }

    func testItFailsValidationForInvalidInput() {
        let result = rule.evaluate(with: "NaN")
        XCTAssertFalse(result)
    }
    
    func testItValidatesCaseInsensitive() {
        let rule = RegexValidationPredicate(expression: "^Case Insensitive$")
        let result = rule.evaluate(with: "case insensitive")
        
        XCTAssertFalse(result)
    }

    func testItFailsValidationForLongInvalidInput() {
        let result = rule.evaluate(with: "0123456789")
        XCTAssertFalse(result)
    }

    func testItPassValidationForValidInput() {
        let result = rule.evaluate(with: "1")
        XCTAssertTrue(result)
    }

    func testItPassValitdationWithUTF8Chars() {
        let rule = RegexValidationPredicate(expression: "^\\p{L}$")
        let result = rule.evaluate(with: "é")
        XCTAssertTrue(result)
    }

    func testItPassValitdationWithUTF16Chars() {
        let rule = RegexValidationPredicate(expression: "^\\p{L}$")
        let result = rule.evaluate(with: "ߘ")
        XCTAssertTrue(result)
    }

    func testItPassValidationWithMandarineChars() {
        let rule = RegexValidationPredicate(expression: "^\\p{L}+$")
        let result = rule.evaluate(with: "我")
        XCTAssertTrue(result)
    }
}
