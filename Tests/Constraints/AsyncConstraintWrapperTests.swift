import XCTest
import Peppermint

final class AsyncConstraintWrapperTests: XCTestCase {

    let constraint = BlockConstraint<String, FakeError> {
        $0 == "validInput"
    } errorBuilder: {
        .Invalid
    }
    

    func testEvaluateAsyncCallsTheCallbackWithASuccessfulResultWhenTheInputIsValid() async throws {
        
        let sut = constraint.async()
        
        let result = await sut.evaluate(with: "validInput")
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testCheckAsyncCallsTheCallbackWithASuccessfulResultWhenTheInputIsValid() async throws {
        
        let sut = constraint.async()
        do {
            let result = try await sut.check("validInput")
            XCTAssertEqual(result, "validInput")
        }
        catch {
            XCTFail()
        }
    }
}
