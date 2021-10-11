import XCTest
@testable import Peppermint

class RequiredConstraintTests: XCTestCase {
    
    func testEvaluateShouldReturnASuccessfulResultWhenTheInputIsValid() {
        let sut = RequiredConstraint<String, FakeError>(error: .Invalid)
        let result = sut.evaluate(with: "input")
        
        switch result {
        case .success: XCTAssert(true)
        case .failure(_): XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenTheInputIsInvalid() {
        let sut = RequiredConstraint<String, FakeError>(error: .Invalid)
        let result = sut.evaluate(with: "")
        
        switch result {
        case .success: XCTFail()
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        }
    }
    
    func testEvaluateShouldDynamicallyBuildTheErrorWhenInitializedWithErrorBlock() {
        let sut = RequiredConstraint<String, FakeError> {
            .Unexpected($0)
        }
        let result = sut.evaluate(with: "")
        
        switch result {
        case .success: XCTFail()
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("")]))
        }
    }
    
    func testEvaluateShouldDynamicallyBuildTheErrorWhenInitialisedWithNoParamErrorBlock() {
        let sut = RequiredConstraint<String, FakeError> {
            .Invalid
        }
        let result = sut.evaluate(with: "")
        
        switch result {
        case .success: XCTFail()
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        }
    }
}
