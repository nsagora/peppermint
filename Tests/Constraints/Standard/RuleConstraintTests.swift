import XCTest
@testable import Peppermint

class RuleConstraintTests: XCTestCase {

    fileprivate let validInput = "validInput"
    fileprivate let invalidInput = "invalidInput"
    fileprivate let rule = FakeRule(expected: "validInput")

    func testEvaluateShouldReturnASuccessfulResultWhenTheInputIsValid() {
        let sut = RuleConstraint(rule, error: FakeError.Invalid)
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }

    func testEvaluateShouldReturnAFailureResultWhenTheInputIsInvalid() {
        let sut = RuleConstraint(rule, error: FakeError.Invalid)
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
}

// MARK: - Convenience Initialisers

extension RuleConstraintTests {

    func testEvaluateShouldDynamicallyBuildTheErrorWhenInitializedWithErrorBlock() {
        let sut = RuleConstraint(rule) { FakeError.Unexpected($0) }
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected(invalidInput)]))
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldDynamicallyBuildTheErrorWhenInitialisedWithNoParamErrorBlock() {
        let sut = RuleConstraint(rule) { FakeError.Invalid }
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
    
    func testEvaluteShouldDynamicallyBuildTheRuleWhenInitialisedWithRuleBuilderAndErrorBuilder() {
        let sut = RuleConstraint {
            self.rule
        } errorBuilder: {
            FakeError.Unexpected($0)
        }
        
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected(invalidInput)]))
        default: XCTFail()
        }
    }
    
    func testEvaluteShouldDynamicallyBuildTheRuleWhenInitialisedWithRuleBuilderAndNoParamErrorBuilder() {
        let sut = RuleConstraint {
            self.rule
        } errorBuilder: {
            FakeError.Invalid
        }
        
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
}
