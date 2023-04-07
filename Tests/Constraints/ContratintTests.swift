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
