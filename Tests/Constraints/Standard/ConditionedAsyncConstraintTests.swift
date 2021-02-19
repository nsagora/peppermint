import XCTest
@testable import ValidationToolkit

class ConditionedAsyncConstraintTests: XCTestCase {

    fileprivate let validFakeInput = "fakeInput"
    fileprivate let invalidFakeInput = "~fakeInput"
    fileprivate let fakePredicate = FakePredicate(expected: "fakeInput")

    func testThatItDynamicallyBuildsTheValidationError() {

        // Given
        let constraint = ConditionedAsyncConstraint(predicate: fakePredicate) { FakeError.Unexpected($0) }

        let summary = Result.Summary(errors: [FakeError.Unexpected(invalidFakeInput)])
        let expectedResult = Result.failure(summary)
        var actualResult: Result!

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

extension ConditionedAsyncConstraintTests {

    func testAddConditions() {

        let p = FakePredicate(expected: "001")
        let condition = ConditionedAsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "002")
        var constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 1)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 2)
    }

    func testThatItDoentEvaluateWhenHavingAFailingCondition() {

        // Given
        let p = FakePredicate(expected: "001")
        let condition = PredicateConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "000")
        var constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let summary = Result.Summary(errors: [FakeError.Invalid])
        let expectedResult = Result.failure(summary)
        var actualResult:Result!

        // When
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "002", queue: .main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertEqual(actualResult, expectedResult)
    }

    func testThatItEvaluateWhenHavingAValidCondition() {

        // When
        let p = FakePredicate(expected: "001")
        let condition = PredicateConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "000")
        var constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let summary = Result.Summary(errors: [FakeError.Invalid])
        let expectedResult = Result.failure(summary)
        var actualResult:Result!

        // Given
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "001", queue: .main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertEqual(actualResult, expectedResult)
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition() {

        // Given
        let p_level_2_1 = FakePredicate(expected: "201")
        var c_level_2_1 = ConditionedAsyncConstraint(predicate: p_level_2_1, error: FakeError.Unexpected("Expecting Level 2.1"))

        let p_level_2_2 = FakePredicate(expected: "202")
        let c_level_2_2 = ConditionedAsyncConstraint(predicate: p_level_2_2, error: FakeError.Unexpected("Expecting Level 2.2"))

        let p_level_1_1 = FakePredicate(expected: "101")
        let c_level_1_1 = ConditionedAsyncConstraint(predicate: p_level_1_1, error: FakeError.Unexpected("Expecting Level 1.1"))

        let p_level_ground = FakePredicate(expected: "001")
        var c_level_ground = ConditionedAsyncConstraint(predicate: p_level_ground, error:FakeError.Unexpected("Expecting Ground"))

        c_level_2_1.add(condition:c_level_2_2)
        c_level_2_1.add(condition:c_level_1_1)
        c_level_ground.add(condition:c_level_2_1)

        var actuallyResult:Result!
        let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting Level 2.1"), FakeError.Unexpected("Expecting Level 2.2")])
        let expectedResult = Result.failure(summary);

        // When
        let expect = expectation(description: "Async Evaluation")
        c_level_ground.evaluate(with: "201", queue: .main) { result in
            actuallyResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertEqual(actuallyResult, expectedResult)
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition_2() {

        // Given
        let p_1 = FakePredicate(expected: "001")
        var condition_1 = ConditionedAsyncConstraint(predicate: p_1, error: FakeError.Unexpected("Expecting 001"))

        let p_2 = FakePredicate(expected: "002")
        let condition_2 = ConditionedAsyncConstraint(predicate: p_2, error: FakeError.Unexpected("Expecting 002"))

        let p_3 = FakePredicate(expected: "003")
        let condition_3 = ConditionedAsyncConstraint(predicate: p_3, error: FakeError.Unexpected("Expecting 003"))

        let predicate = FakePredicate(expected: "004")
        var constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        condition_1.add(condition:condition_2)
        condition_1.add(condition:condition_3)
        constraint.add(condition:condition_1)

        let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
        let expectedResult = Result.failure(summary)
        var actualResult:Result!

        // When
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "004", queue: .main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertEqual(actualResult, expectedResult)
    }
}
