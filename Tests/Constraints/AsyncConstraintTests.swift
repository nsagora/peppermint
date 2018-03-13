import XCTest
@testable import ValidationToolkit

class AsyncConstraintTests: XCTestCase {

    func testCanAddAsyncPredicate() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        XCTAssertNotNil(constraint)
    }
    
    func testItCanBeInstantiatedWithErrorBlock() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error: { FakeError.Unexpected("Input \($0) is invalid") })
        
        XCTAssertNotNil(constraint)
    }
    
    func testThatItCanValidate() {
        
        let predicate = FakePredicate(expected: Int.max)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testThatItCallsCallbackWithSucceesOnSuccess() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 10, queue:.main) { result in
            XCTAssertTrue(result.isValid)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
    }
    
    func testThatItCallsCallbackWithErrorOnError() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            XCTAssertTrue(result.isInvalid)
            XCTAssertTrue(result.summary.errors is [FakeError])
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
        
    }
}

extension AsyncConstraintTests {

    func testAddConditions() {

        let p = FakePredicate(expected: "001")
        let condition = SimpleAsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "002")
        var constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 1)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 2)
    }

    func testThatItDoentEvaluateWhenHavingAFailingCondition() {

        let p = FakePredicate(expected: "001")
        let condition = SimpleAsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "000")
        var constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "002", queue: .main) { result in
            let expectedResult = Result.Summary(errors: [FakeError.Invalid])
            XCTAssertEqual(result, Result.invalid(expectedResult))
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testThatItEvaluateWhenHavingAValidCondition() {

        let p = FakePredicate(expected: "001")
        let condition = SimpleAsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate(expected: "000")
        var constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "001", queue: .main) { result in
            let expectedResult = Result.Summary(errors: [FakeError.Invalid])
            XCTAssertEqual(result, Result.invalid(expectedResult))
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition() {

        let p_1 = FakePredicate(expected: "001")
        var condition_1 = SimpleAsyncConstraint(predicate: p_1, error: FakeError.Unexpected("Expecting 001"))

        let p_2 = FakePredicate(expected: "002")
        let condition_2 = SimpleAsyncConstraint(predicate: p_2, error: FakeError.Unexpected("Expecting 002"))

        let p_3 = FakePredicate(expected: "003")
        let condition_3 = SimpleAsyncConstraint(predicate: p_3, error: FakeError.Unexpected("Expecting 003"))

        let predicate = FakePredicate(expected: "000")
        var constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        condition_1.add(condition:condition_2)
        condition_1.add(condition:condition_3)
        constraint.add(condition:condition_1)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "001", queue: .main) { result in
            let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
            XCTAssertEqual(result, Result.invalid(summary))
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition_2() {

        let p_1 = FakePredicate(expected: "001")
        var condition_1 = SimpleAsyncConstraint(predicate: p_1, error: FakeError.Unexpected("Expecting 001"))

        let p_2 = FakePredicate(expected: "002")
        let condition_2 = SimpleAsyncConstraint(predicate: p_2, error: FakeError.Unexpected("Expecting 002"))

        let p_3 = FakePredicate(expected: "003")
        let condition_3 = SimpleAsyncConstraint(predicate: p_3, error: FakeError.Unexpected("Expecting 003"))

        let predicate = FakePredicate(expected: "004")
        var constraint = SimpleAsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        condition_1.add(condition:condition_2)
        condition_1.add(condition:condition_3)
        constraint.add(condition:condition_1)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "004", queue: .main) { result in
            let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
            XCTAssertEqual(result, Result.invalid(summary))
            expect.fulfill()
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
