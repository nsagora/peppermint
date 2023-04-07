import XCTest
import Peppermint

final class QueuedConstraintWrapperTests: XCTestCase {

    let constraint = BlockConstraint<String, FakeError> {
        $0 == "validInput"
    } errorBuilder: {
        .Invalid
    }

    func testEvaluateOnQueueCallsTheCallbackWithASuccessfulResultWhenTheInputIsValid() throws {
        
        let sut = constraint.queued()
        
        let expect = expectation(description: "Async Evaluation")
        
        var actualResult: Result<Void, Summary<FakeError>>!
        sut.evaluate(with: "validInput", on:.main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        switch actualResult {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
}
