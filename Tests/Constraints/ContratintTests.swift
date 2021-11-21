import XCTest
@testable import Peppermint

class ConstraintTests: XCTestCase {
}

// MARK: - Check Evaluation

extension ConstraintTests {
    
    func testThatCheckReturnsTheInputWhenEvaluationIsSuccessful() {
        let sut = BlockConstraint<String, FakeError> {
            $0 == "validInput"
        } errorBuilder: {
            .Invalid
        }
        
        do {
            let result = try sut.check("validInput")
            XCTAssertEqual(result, "validInput")
        }
        catch {
            XCTFail()
        }
    }
    
    func testThatCheckThrowsTheSummaryWhenEvaluationFails() {
        let sut = BlockConstraint<String, FakeError> {
            $0 == "validInput"
        } errorBuilder: {
            .Unexpected($0)
        }
        
        do {
            let _ = try sut.check("invalidInput")
            XCTFail()
        }
        catch let error as Summary<FakeError> {
            XCTAssertEqual(error, Summary<FakeError>(errors: [.Unexpected("invalidInput")]))
        }
        catch {
            XCTFail()
        }
    }
}

// MARK: - Async Evaluation

extension ConstraintTests {
    
    func testEvaluateAsyncCallsTheCallbackWithASuccessfulResultWhenTheInputIsValid() {
        let sut = BlockConstraint<String, FakeError> {
            $0 == "validInput"
        } errorBuilder: {
            .Invalid
        }
        let expect = expectation(description: "Async Evaluation")
        
        var actualResult: Result<Void, Summary<FakeError>>!
        sut.evaluate(with: "validInput", queue:.main) { result in
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
    
    func testEvaluateAsyncCallsTheCallbackWithAFailureResultWhenTheInputIsInvalid() {
        let sut = BlockConstraint<String, FakeError> {
            $0 == "validInput"
        } errorBuilder: {
            .Unexpected($0)
        }
        let expect = expectation(description: "Async Evaluation")
        
        var actualResult: Result<Void, Summary<FakeError>>!
        sut.evaluate(with: "invalidInput", queue:.main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
        
        switch actualResult {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("invalidInput")]))
        default: XCTFail()
        }
    }
}
