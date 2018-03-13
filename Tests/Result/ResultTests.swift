import XCTest
@testable import ValidationToolkit

class ResultTests: XCTestCase {

    func testIsValid() {
        XCTAssertTrue(Result.valid.isValid)
        XCTAssertFalse(Result.valid.isInvalid)
    }
    
    func testIsInvalid() {
        
        let summary = Result.Summary(errors: [TestError.InvalidInput])
        let invalidResult: Result = Result.invalid(summary)

        XCTAssertTrue(invalidResult.isInvalid)
        XCTAssertFalse(invalidResult.isValid)
    }
    
    func testEvaluationErrors() {
        let errors =  [TestError.InvalidInput]
        let expectedSummary = Result.Summary(errors:errors)

        let invalidResult = Result.invalid(expectedSummary)
        XCTAssertTrue(invalidResult.summary.hasFailingContraints)

        let validResult = Result.valid
        XCTAssertFalse(validResult.summary.hasFailingContraints)
    }
}

// MARK: - Test Error

fileprivate enum TestError: Error {
    case InvalidInput
}
