import XCTest
@testable import ValidationToolkit

class ResultTests: XCTestCase {

    func testIsValid() {
        XCTAssertTrue(Result.success.isSuccessful)
        XCTAssertFalse(Result.success.isFailed)
    }
    
    func testIsInvalid() {
        
        let summary = Result.Summary(errors: [FakeError.Invalid])
        let invalidResult: Result = Result.failure(summary)

        XCTAssertTrue(invalidResult.isFailed)
        XCTAssertFalse(invalidResult.isSuccessful)
    }

    func testThatValidIsNotEqualToInvalid() {

        let summary = Result.Summary(errors: [FakeError.Invalid])

        XCTAssertNotEqual(Result.success, Result.failure(summary))
    }
    
    func testEvaluationErrors() {
        let errors =  [FakeError.Invalid]
        let expectedSummary = Result.Summary(errors:errors)

        let invalidResult = Result.failure(expectedSummary)
        XCTAssertTrue(invalidResult.summary.hasFailingContraints)

        let validResult = Result.success
        XCTAssertFalse(validResult.summary.hasFailingContraints)
    }
}
