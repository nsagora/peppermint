import XCTest
@testable import Peppermint

class BlockConstraintTests: XCTestCase {
    
    fileprivate let validInput = "validInput"
    fileprivate let invalidInput = "invalidInput"
    
    func testEvaluateShouldReturnAValidResultWhenInputIsValid() {
        
        let sut = BlockConstraint<String, FakeError> {
            $0 == "validInput"
        } errorBuilder: {
            .Invalid
        }
        
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenInputIsInvalid() {
        
        let sut = BlockConstraint<String, FakeError> {
            $0 == "validInput"
        } errorBuilder: {
            .Unexpected($0)
        }
        
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected(invalidInput)]))
        default: XCTFail()
        }
    }
}
