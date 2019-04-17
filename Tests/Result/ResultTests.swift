import XCTest
@testable import ValidationToolkit

class ResultTests: XCTestCase {

    func testIsValid() {
        XCTAssertTrue(ValidationResult.success.isValid)
        XCTAssertFalse(ValidationResult.success.isInvalid)
    }
    
    func testIsInvalid() {
        
        let summary = ValidationResult.Summary(errors: [FakeError.Invalid])
        let invalidResult: ValidationResult = ValidationResult.failure(summary)

        XCTAssertTrue(invalidResult.isInvalid)
        XCTAssertFalse(invalidResult.isValid)
    }

    func testThatValidIsNotEqualToInvalid() {

        let summary = ValidationResult.Summary(errors: [FakeError.Invalid])

        XCTAssertNotEqual(ValidationResult.success, ValidationResult.failure(summary))
    }
    
    func testEvaluationErrors() {
        let errors =  [FakeError.Invalid]
        let expectedSummary = ValidationResult.Summary(errors:errors)

        let invalidResult = ValidationResult.failure(expectedSummary)
        XCTAssertTrue(invalidResult.summary.hasFailingContraints)

        let validResult = ValidationResult.success
        XCTAssertFalse(validResult.summary.hasFailingContraints)
    }
}
