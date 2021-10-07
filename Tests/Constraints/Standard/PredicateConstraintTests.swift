import XCTest
@testable import Peppermint

class PredicateConstraintTests: XCTestCase {

    fileprivate let validInput = "validInput"
    fileprivate let invalidInput = "invalidInput"
    fileprivate let predicate = FakePredicate(expected: "validInput")

    func testEvaluateShouldReturnASuccessfulResultWhenTheInputIsValid() {
        let sut = PredicateConstraint(predicate, error: FakeError.Invalid)
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }

    func testEvaluateShouldReturnAFailureResultWhenTheInputIsInvalid() {
        let sut = PredicateConstraint(predicate, error: FakeError.Invalid)
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
}

// MARK: - Convenience Initialisers

extension PredicateConstraintTests {

    func testEvaluateShouldDynamicallyBuildTheErrorWhenInitializedWithErrorBlock() {
        let sut = PredicateConstraint(predicate) { FakeError.Unexpected($0) }
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected(invalidInput)]))
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldDynamicallyBuildTheErrorWhenInitialisedWithNoParamErrorBlock() {
        let sut = PredicateConstraint(predicate) { FakeError.Invalid }
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
    
    func testEvaluteShouldDynamicallyBuildThePredicateWhenInitialisedWithPredicateBuilderAndErrorBuilder() {
        let sut = PredicateConstraint {
            self.predicate
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
    
    func testEvaluteShouldDynamicallyBuildThePredicateWhenInitialisedWithPredicateBuilderAndNoParamErrorBuilder() {
        let sut = PredicateConstraint {
            self.predicate
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

// MARK: - Async Evaluation

extension PredicateConstraintTests {
    
    func testEvaluateAsyncCallsTheCallbackWithASuccessfulResultWhenTheInputIsValid() {
        let sut = PredicateConstraint(predicate, error: FakeError.Invalid)
        let expect = expectation(description: "Async Evaluation")
        
        var actualResult: Result<Void, Summary<FakeError>>!
        sut.evaluate(with: validInput, queue:.main) { result in
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
        let sut = PredicateConstraint(predicate, error: FakeError.Invalid)
        let expect = expectation(description: "Async Evaluation")
        
        var actualResult: Result<Void, Summary<FakeError>>!
        sut.evaluate(with: invalidInput, queue:.main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
        
        switch actualResult {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
}
