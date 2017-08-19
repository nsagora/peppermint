//
//  EmailPredicateTests.swift
//  Validator
//
//  Created by Alex Cristea on 07/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class EmailPredicateTests: XCTestCase {

    var predicate: EmailPredicate!

    override func setUp() {
        super.setUp()
        predicate = EmailPredicate()
    }
    
    override func tearDown() {
        predicate = nil
        super.tearDown()
    }

    func testThatItFailsForInvalidEmail() {
        let email = "test@"
        let result = predicate.evaluate(with: email)
        XCTAssertFalse(result)
    }

    func testThatItPassesForValidEmail() {
        let email = "test@example.com"
        let result = predicate.evaluate(with: email)
        XCTAssertTrue(result)
    }

    func testThatItPassesForUTF8() {
        let email = "tést@example.com"
        let result = predicate.evaluate(with: email)
        XCTAssertTrue(result)
    }
}
