import XCTest
@testable import ValidationToolkit

class AsyncConstraintTests: XCTestCase {

    func testCanAddAsyncPredicate() {
        
        let predicate = FakePredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        XCTAssertNotNil(constraint)
    }
    
    func testItCanBeInstantiatedWithErrorBlock() {
        
        let predicate = FakePredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error: { FakeError.Wrong($0) })
        
        XCTAssertNotNil(constraint)
    }
    
    func testThatItCanValidate() {
        
        let predicate = FakePredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testThatItCallsCallbackWithSucceesOnSuccess() {
        
        var predicate = FakePredicate<Int>()
        predicate.expected = 10
        
        let constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 10, queue:.main) { result in
            XCTAssertTrue(result.isValid)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
    }
    
    func testThatItCallsCallbackWithErrorOnError() {
        
        var predicate = FakePredicate<Int>()
        predicate.expected = 10
        
        let constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            XCTAssertTrue(result.isInvalid)
            XCTAssertTrue(result.errors is [FakeError])
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
    }
}

extension AsyncConstraintTests {

    func testAddConditions() {

        let p = FakePredicate(expected: "001")
        let condition = AsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate<String>()
        var constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 1)

        constraint.add(condition:condition)
        XCTAssertEqual(constraint.conditions.count, 2)
    }

    func testThatItDoentEvaluateWhenHavingAFailingCondition() {

        let p = FakePredicate(expected: "001")
        let condition = AsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate<String>()
        var constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "002", queue: .main) { result in
            let expectedResult = Result.Summary(errors: [FakeError.Invalid])
            XCTAssertEqual(result, Result.invalid(expectedResult))
            expect.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testThatItEvaluateWhenHavingAValidCondition() {

        let p = FakePredicate(expected: "001")
        let condition = AsyncConstraint(predicate: p, error: FakeError.Invalid)

        let predicate = FakePredicate<String>()
        var constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        constraint.add(condition:condition)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "001", queue: .main) { result in
            let expectedResult = Result.Summary(errors: [FakeError.Invalid])
            XCTAssertEqual(result, Result.invalid(expectedResult))
            expect.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition() {

        let p_1 = FakePredicate(expected: "001")
        var condition_1 = AsyncConstraint(predicate: p_1, error: FakeError.Unexpected("Expecting 001"))

        let p_2 = FakePredicate(expected: "002")
        let condition_2 = AsyncConstraint(predicate: p_2, error: FakeError.Unexpected("Expecting 002"))

        let p_3 = FakePredicate(expected: "003")
        let condition_3 = AsyncConstraint(predicate: p_3, error: FakeError.Unexpected("Expecting 003"))

        let predicate = FakePredicate<String>()
        var constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        condition_1.add(condition:condition_2)
        condition_1.add(condition:condition_3)
        constraint.add(condition:condition_1)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "001", queue: .main) { result in
            let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
            XCTAssertEqual(result, Result.invalid(summary))
            expect.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition_2() {

        let p_1 = FakePredicate(expected: "001")
        var condition_1 = AsyncConstraint(predicate: p_1, error: FakeError.Unexpected("Expecting 001"))

        let p_2 = FakePredicate(expected: "002")
        let condition_2 = AsyncConstraint(predicate: p_2, error: FakeError.Unexpected("Expecting 002"))

        let p_3 = FakePredicate(expected: "003")
        let condition_3 = AsyncConstraint(predicate: p_3, error: FakeError.Unexpected("Expecting 003"))

        let predicate = FakePredicate<String>()
        var constraint = AsyncConstraint(predicate: predicate, error:FakeError.Invalid)

        condition_1.add(condition:condition_2)
        condition_1.add(condition:condition_3)
        constraint.add(condition:condition_1)

        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: "004", queue: .main) { result in
            let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 002"), FakeError.Unexpected("Expecting 003")])
            XCTAssertEqual(result, Result.invalid(summary))
            expect.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}


extension AsyncConstraintTests {
    
    fileprivate enum FakeError:Error {
        case Invalid
        case Wrong(Int)
        case Unexpected(String)
    }
    
    fileprivate struct FakePredicate<T:Equatable>: AsyncPredicate {

        var expected:T?
        
        func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (Bool) -> Void) {
            
            queue.async {
                completionHandler(self.expected == input)
            }

        }
    }
}
