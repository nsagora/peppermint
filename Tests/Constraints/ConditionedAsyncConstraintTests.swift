import XCTest
@testable import ValidationToolkit

class ConditionedAsyncConstraintTests: XCTestCase {

    fileprivate let validFakeInput = "fakeInput"
    fileprivate let invalidFakeInput = "~fakeInput"
    fileprivate let fakePredicate = FakePredicate(expected: "fakeInput")

    func testThatItDynamicallyBuildsTheValidationError() {

        // Given
        let constraint = ConditionedAsyncConstraint(predicate: fakePredicate) { FakeError.Unexpected($0) }

        let summary = ValidationResult.Summary(errors: [FakeError.Unexpected(invalidFakeInput)])
        let expectedResult = ValidationResult.failure(summary)
        var actualResult: ValidationResult!

        // When
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: invalidFakeInput, queue: .main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertEqual(actualResult, expectedResult)
    }
}
