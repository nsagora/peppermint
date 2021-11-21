import XCTest
@testable import Peppermint

class SummaryTests: XCTestCase {
    
    func testHasFailingConstraintsShouldReturnTrueWhenThereAreErrors() {
        let errors =  [FakeError.Invalid]
        let sut = Summary(errors: errors)

        XCTAssertTrue(sut.hasFailingConstraints)
    }
    
    func testFailingConstraintsShouldReturn1WhenThereIsOnly1Error() {
        let errors =  [FakeError.Invalid]
        let sut = Summary(errors: errors)

        XCTAssertEqual(sut.failingConstraints, 1)
    }
}
