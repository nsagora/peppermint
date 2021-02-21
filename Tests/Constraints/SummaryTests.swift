import XCTest
@testable import ValidationToolkit

class SummaryTests: XCTestCase {

    func testSuccessState() {
        let result = Result<Void, Summary<FakeError>>.success(())
        
        XCTAssertTrue(result.isSuccessful)
        XCTAssertFalse(result.isFailure)
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
        switch invalidResult {
        case .failure(let summary):
            XCTAssertTrue(summary.hasFailingContraints)
        default:
            XCTFail()
        }
    }
}
