//
//  EvaluationResultTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 17/09/2016.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class EvaluationResultTests: XCTestCase {

    func testIsValid() {
        XCTAssertTrue(EvaluationResult.valid.isValid)
        XCTAssertFalse(EvaluationResult.valid.isInvalid)
    }
    
    func testIsInvalid() {
        XCTAssertTrue(EvaluationResult.invalid(TestError.InvalidInput).isInvalid)
        XCTAssertFalse(EvaluationResult.invalid(TestError.InvalidInput).isValid)
    }
    
    func testEvaluationError() {
        XCTAssertTrue(EvaluationResult.invalid(TestError.InvalidInput).error != nil)
        XCTAssertTrue(EvaluationResult.valid.error == nil)
    }
}

// MARK: - Test Error

fileprivate enum TestError: Error {
    case InvalidInput
}
