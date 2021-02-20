import XCTest
@testable import ValidationToolkit

class PredicateConstraintTests: XCTestCase {

    fileprivate let validInput = "validInput"
    fileprivate let invalidInput = "invalidInput"
    fileprivate let predicate = FakePredicate(expected: "validInput")

    func testEvaluateShouldReturnASuccessfulResultWhenTheInputIsValid() {
        
        let sut = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        let result = sut.evaluate(with: validInput)
        
        XCTAssertTrue(result.isSuccessful)
    }

    func testEvaluateShouldReturnAFailureResultWhenTheInputIsInvalid() {

        let sut = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        let result = sut.evaluate(with: invalidInput)

        XCTAssertTrue(result.isFailure)
        XCTAssertEqual(result.summary.failingConstraints, 1)

        let expectedErrors = [FakeError.Invalid]
        let actualErrors = result.summary.errors as! [FakeError]
        XCTAssertEqual(actualErrors, expectedErrors)
    }
}

extension PredicateConstraintTests {
    
    func testEvaluateShouldDynamicallyBuildTheErrorWhenInitialisedWithErrorBlock() {

        let sut = PredicateConstraint(predicate: predicate) { FakeError.Unexpected($0) }
        let result = sut.evaluate(with: invalidInput)

        let actualErrors = result.summary.errors as! [FakeError]
        let expectedErrors = [FakeError.Unexpected(invalidInput)]
        XCTAssertTrue(result.isFailure)
        XCTAssertEqual(actualErrors, expectedErrors)
    }
}

extension PredicateConstraintTests {
    
    func testEvaluateAsyncCallsTheCallbackWithASuccessfulResultWhenTheInputIsValid() {

        let sut = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let expect = expectation(description: "Async Evaluation")
        
        var actualResult: Result<Void, Summary>!
        sut.evaluate(with: validInput, queue:.main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        XCTAssertTrue(actualResult.isSuccessful)
    }
    
    func testEvaluateAsyncCallsTheCallbackWithAFailureResultWhenTheInputIsInvalid() {

        let sut = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let expect = expectation(description: "Async Evaluation")
        
        var actualResult: Result<Void, Summary>!
        sut.evaluate(with: invalidInput, queue:.main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        let actualErrors = actualResult.summary.errors as! [FakeError]
        let expectedErrors = [FakeError.Invalid]
        XCTAssertTrue(actualResult.isFailure)
        XCTAssertEqual(actualErrors, expectedErrors)
    }
}
