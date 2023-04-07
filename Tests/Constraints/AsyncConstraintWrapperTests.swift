import XCTest
@testable import Peppermint

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
    
    func testCheckAsyncCallsTheCallbackWithAFailureResultWhenTheInputIsInvalid() async throws {
        
        let sut = constraint.async()
        do {
            let _ = try await sut.check("invalidInput")
        }
        catch let error as Summary<FakeError> {
            XCTAssertEqual(error, Summary<FakeError>(errors: [.Invalid]))
        }
        catch {
            XCTFail()
        }
    }
}
