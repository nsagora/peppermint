import XCTest
@testable import Peppermint

class OptionalConstraintTests: XCTestCase {
    
    fileprivate var validInput: String? = "validInput"
    fileprivate let invalidInput = "invalidInput"
    
    func testEvaluateShouldReturnAValidResultWhenTheUnwrappedInputIsValid() {
        
        let sut = OptionalConstraint<String, FakeError> {
            BlockConstraint<String, FakeError> {
                $0 == "validInput"
            } errorBuilder: {
                .Invalid
            }
        }
        
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAValidResultWhenTheInputIsNil() {
        
        let sut = OptionalConstraint<String, FakeError> {
            BlockConstraint<String, FakeError> {
                $0 == "validInput"
            } errorBuilder: {
                .Invalid
            }
        }
        
        let result = sut.evaluate(with: nil)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenTheUnwrappedInputIsInvalid() {
        
        let sut = OptionalConstraint<String, FakeError>{
            BlockConstraint<String, FakeError> {
                $0 == "validInput"
            } errorBuilder: {
                .Invalid
            }
        }
        
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenTheInputIsNilAndTheConstraintWasInitiatedWithARequiredError() {
        
        let sut = OptionalConstraint<String, FakeError>(required: .MissingInput){
            BlockConstraint<String, FakeError> {
                $0 == "validInput"
            } errorBuilder: {
                .Invalid
            }
        }
        
        let result = sut.evaluate(with: nil)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.MissingInput]))
        default: XCTFail()
        }
    }
}
