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
        
        let summary = EvaluationResult.Summary(errors: [TestError.InvalidInput])
        
        XCTAssertTrue(EvaluationResult.invalid(summary).isInvalid)
        XCTAssertFalse(EvaluationResult.invalid(summary).isValid)
    }
    
    func testEvaluationErrors() {
        let errors =  [TestError.InvalidInput]
        let summary = EvaluationResult.Summary(errors:errors)
        
        XCTAssertEqual(errors, EvaluationResult.invalid(summary).errors as! [TestError])
        XCTAssertTrue(EvaluationResult.valid.errors == nil)
    }
}

// MARK: - Test Error

fileprivate enum TestError: Error {
    case InvalidInput
}
