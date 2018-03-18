import XCTest
@testable import ValidationToolkit

class AsyncConstraintTests: XCTestCase {

    func testCanAddAsyncPredicate() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = SimpleConstraint(predicate: predicate, error:FakeError.Invalid)
        
        XCTAssertNotNil(constraint)
    }
    
    func testItCanBeInstantiatedWithErrorBlock() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = SimpleConstraint(predicate: predicate, error: { FakeError.Unexpected("Input \($0) is invalid") })
        
        XCTAssertNotNil(constraint)
    }
    
    func testThatItCanValidate() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = SimpleConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatItCallsCallbackWithSucceesOnSuccess() {

        // Given
        let predicate = FakePredicate(expected: 10)
        let constraint = SimpleConstraint(predicate: predicate, error:FakeError.Invalid)

        var actualResult:Result!

        // When
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 10, queue:.main) { result in
            actualResult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertTrue(actualResult.isValid)
    }
    
    func testThatItCallsCallbackWithErrorOnError() {

        // Given
        let predicate = FakePredicate(expected: 10)
        let constraint = SimpleConstraint(predicate: predicate, error:FakeError.Invalid)
        
        var actualresult:Result!

        // When
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            actualresult = result
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertTrue(actualresult.isInvalid)
        XCTAssertTrue(actualresult.summary.errors is [FakeError])
    }
}

extension AsyncConstraintTests {

    func testAddConditions() {

        let p = FakePredicate(expected: "001")
        let condition = ConditionedAsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "002")
        let constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 1)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 2)
    }

    func testThatItDoentEvaluateWhenHavingAFailingCondition() {

        // Given
        let p = FakePredicate(expected: "001")
        let condition = SimpleConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "000")
        let constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let summary = Result.Summary(errors: [FakeError.Invalid])
        let expectedResult = Result.invalid(summary)
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
        let condition = SimpleConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "000")
        let constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let summary = Result.Summary(errors: [FakeError.Invalid])
        let expectedResult = Result.invalid(summary)
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
        let c_level_2_1 = ConditionedAsyncConstraint(predicate: p_level_2_1, error: FakeError.Unexpected("Expecting Level 2.1"))

        let p_level_2_2 = FakePredicate(expected: "202")
        let c_level_2_2 = ConditionedAsyncConstraint(predicate: p_level_2_2, error: FakeError.Unexpected("Expecting Level 2.2"))

        let p_level_1_1 = FakePredicate(expected: "101")
        let c_level_1_1 = ConditionedAsyncConstraint(predicate: p_level_1_1, error: FakeError.Unexpected("Expecting Level 1.1"))

        let p_level_ground = FakePredicate(expected: "001")
        let c_level_ground = ConditionedAsyncConstraint(predicate: p_level_ground, error:FakeError.Unexpected("Expecting Ground"))

        c_level_2_1.add(condition:c_level_2_2)
        c_level_2_1.add(condition:c_level_1_1)
        c_level_ground.add(condition:c_level_2_1)

        var actuallyResult:Result!
        let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting Level 2.1"), FakeError.Unexpected("Expecting Level 2.2")])
        let expectedResult = Result.invalid(summary);

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
        let condition_1 = ConditionedAsyncConstraint(predicate: p_1, error: FakeError.Unexpected("Expecting 001"))

        let p_2 = FakePredicate(expected: "002")
        let condition_2 = ConditionedAsyncConstraint(predicate: p_2, error: FakeError.Unexpected("Expecting 002"))

        let p_3 = FakePredicate(expected: "003")
        let condition_3 = ConditionedAsyncConstraint(predicate: p_3, error: FakeError.Unexpected("Expecting 003"))

        let predicate = FakePredicate(expected: "004")
        let constraint = ConditionedAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        condition_1.add(condition:condition_2)
        condition_1.add(condition:condition_3)
        constraint.add(condition:condition_1)

        let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
        let expectedResult = Result.invalid(summary)
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
