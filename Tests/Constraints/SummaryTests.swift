import XCTest
@testable import ValidationToolkit

class SummaryTests: XCTestCase {
    
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
