import XCTest
@testable import ValidationToolkit

class SummaryTests: XCTestCase {

    func testSuccessState() {
        XCTAssertTrue(Result<Void, Summary>.success().isSuccessful)
        XCTAssertFalse(Result<Void, Summary>.success().isFailure)
    }
    
    func testFailureState() {
        
        let summary = Summary(errors: [FakeError.Invalid])
        let invalidResult = Result<Void, Summary>.failure(summary)

        XCTAssertTrue(invalidResult.isFailure)
        XCTAssertFalse(invalidResult.isSuccessful)
    }
    
    func testGasFailingContraintsShouldReturnTrueWhenThereAreErrors() {
        let errors =  [FakeError.Invalid]
        let expectedSummary = Summary(errors: errors)

        let invalidResult = Result<Void, Summary>.failure(expectedSummary)
        XCTAssertTrue(invalidResult.summary.hasFailingContraints)

        let validResult = Result<Void, Summary>.success(())
        XCTAssertFalse(validResult.summary.hasFailingContraints)
    }
}
