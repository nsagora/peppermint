import XCTest
@testable import ValidationToolkit

class AsyncPredicateConstraintTests: XCTestCase {

    func testCanAddAsyncPredicate() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        
        XCTAssertNotNil(constraint)
    }
    
    func testItCanBeInstantiatedWithErrorBlock() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = PredicateConstraint(predicate: predicate, error: { FakeError.Unexpected("Input \($0) is invalid") })
        
        XCTAssertNotNil(constraint)
    }
    
    func testThatItCanValidate() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatItCallsCallbackWithSucceesOnSuccess() {

        // Given
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        var actualResult:Result!

        // When
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 10, queue:.main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertTrue(actualResult.isSuccessful)
    }
    
    func testThatItCallsCallbackWithErrorOnError() {

        // Given
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        
        var actualresult:Result!

        // When
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            actualresult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertTrue(actualresult.isFailed)
        XCTAssertTrue(actualresult.summary.errors is [FakeError])
    }
}
