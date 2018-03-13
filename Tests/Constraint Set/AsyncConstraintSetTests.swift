import XCTest
@testable import ValidationToolkit

class AsyncConstraintSetTests: XCTestCase {
    
    var constraintSet: AsyncConstraintSet<Int>!
    
    override func setUp() {
        super.setUp()
        constraintSet = AsyncConstraintSet<Int>()
    }

    override func tearDown() {
        constraintSet = nil
        super.tearDown()
    }
    
    func testItCanBeInstantiated() {
    
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 0)
    }
    
    func testItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {

        let constraints = [AnyAsyncConstraint<Int>]()
        let constraintSet = AsyncConstraintSet<Int>(constraints:constraints)
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 0)
    }
    
    func testItCanBeInstantiatedWithAPredefinedArrayOfConstraints() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncConstraintSet<Int>(constraints: [constraint])
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testItCanBeInstantiatedWithAUndefinedNumberOfConstraints() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncConstraintSet<Int>(constraints: constraint)
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanAddAnAsynConstraint() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = SimpleAsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        constraintSet.add(constraint: constraint)
        
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testItCanAddMultipleAsyncConstraints() {
        
        let aPredicate = FakePredicate(expected: 10)
        let aConstraint = SimpleAsyncConstraint(predicate: aPredicate, error: FakeError.Invalid);
        
        let bPredicate = FakePredicate(expected: 10)
        let bConstraint = SimpleAsyncConstraint(predicate: bPredicate, error: FakeError.Invalid);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)
        
        XCTAssertEqual(constraintSet.count, 2)
    }
    
    func testItCanAddAConstraintUsingAlternativeMethod() {
        
        let predicate = FakePredicate(expected: 10)
        constraintSet.add(predicate: predicate, error:FakeError.Invalid)
        
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanEvaluateAny_ForOneConstraint() {

        constraintSet.add(predicate: FakePredicate(expected: 10), error: FakeError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraintSet.evaluateAny(input: 1) { result in
            expect.fulfill()
            switch result {
            case .invalid(_): XCTAssert(true)
            default: XCTFail()
            }
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint() {
        constraintSet.add(predicate: FakePredicate(expected: 10), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(expected: 20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 1) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint2() {

        constraintSet.add(predicate: FakePredicate(expected: 10), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(expected: 20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint3() {

        constraintSet.add(predicate: FakePredicate(expected: 20), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(expected: 20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isValid)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testItCanEvaluateAll_ToValid() {

        constraintSet.add(predicate: FakePredicate(expected: 1), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(expected: 1), error: FakeError.FailingCondition)

        let expect = expectation(description: "Evaluate all async")
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.valid, result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_2() {

        constraintSet.add(predicate: FakePredicate(expected: 1), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(expected: 2), error: FakeError.FailingCondition)

        let expect = expectation(description: "Evaluate all async")
        let summary = Result.Summary(errors: [FakeError.FailingCondition])
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.invalid(summary), result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_3() {

        constraintSet.add(predicate: FakePredicate(expected: 2), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(expected: 2), error: FakeError.FailingCondition)

        let expect = expectation(description: "Evaluate all async")
        let summary = Result.Summary(errors: [FakeError.Invalid, FakeError.FailingCondition])
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.invalid(summary), result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
