import XCTest
@testable import Peppermint

class SummaryTests: XCTestCase {
    
    func testGasFailingConstraintsShouldReturnTrueWhenThereAreErrors() {
        let errors =  [FakeError.Invalid]
        let expectedSummary = Summary(errors: errors)

        let invalidResult = Result<Void, Summary>.failure(expectedSummary)
        
        switch invalidResult {
        case .failure(let summary):
            XCTAssertTrue(summary.hasFailingConstraints)
        default: XCTFail()
        }
    }
}
