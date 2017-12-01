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
        XCTAssertTrue(Result.valid.isValid)
        XCTAssertFalse(Result.valid.isInvalid)
    }
    
    func testIsInvalid() {
        
        let summary = Result.Summary(errors: [TestError.InvalidInput])
        
        XCTAssertTrue(Result.invalid(summary).isInvalid)
        XCTAssertFalse(Result.invalid(summary).isValid)
    }
    
    func testEvaluationErrors() {
        let errors =  [TestError.InvalidInput]
        let summary = Result.Summary(errors:errors)
        
        XCTAssertEqual(errors, Result.invalid(summary).errors as! [TestError])
        XCTAssertTrue(Result.valid.errors == nil)
    }
}

// MARK: - Test Error

fileprivate enum TestError: Error {
    case InvalidInput
}
