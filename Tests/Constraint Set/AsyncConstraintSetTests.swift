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
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncConstraintSet<Int>(constraints: [constraint])
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testItCanBeInstantiatedWithAUndefinedNumberOfConstraints() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncConstraintSet<Int>(constraints: constraint)
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanAddAnAsynConstraint() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid);
        
        constraintSet.add(constraint: constraint)
        
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testItCanAddMultipleAsyncConstraints() {
        
        let aPredicate = FakePredicate(expected: 10)
        let aConstraint = PredicateConstraint(predicate: aPredicate, error: FakeError.Invalid);
        
        let bPredicate = FakePredicate(expected: 10)
        let bConstraint = PredicateConstraint(predicate: bPredicate, error: FakeError.Invalid);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)
        
        XCTAssertEqual(constraintSet.count, 2)
    }
    
    func testItCanAddAConstraintUsingAlternativeMethod() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        constraintSet.add(constraint: constraint)
        
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanEvaluateAny_ForOneConstraint() {

        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        constraintSet.add(constraint: constraint)
        
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

        // Given
        let aPredicate = FakePredicate(expected: 10)
        let aConstraint = PredicateConstraint(predicate: aPredicate, error: FakeError.Invalid);

        let bPredicate = FakePredicate(expected: 10)
        let bConstraint = PredicateConstraint(predicate: bPredicate, error: FakeError.Invalid);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)

        // When
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 1) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint2() {

        // Given
        let aPredicate = FakePredicate(expected: 10)
        let aConstraint = PredicateConstraint(predicate: aPredicate, error: FakeError.Invalid);

        let bPredicate = FakePredicate(expected: 10)
        let bConstraint = PredicateConstraint(predicate: bPredicate, error: FakeError.Invalid);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)

        // When
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint3() {

        // Given
        let aPredicate = FakePredicate(expected: 20)
        let aConstraint = PredicateConstraint(predicate: aPredicate, error: FakeError.Invalid);

        let bPredicate = FakePredicate(expected: 20)
        let bConstraint = PredicateConstraint(predicate: bPredicate, error: FakeError.Invalid);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)

        // When
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isValid)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testItCanEvaluateAll_ToValid() {

        // Given
        let aPredicate = FakePredicate(expected: 1)
        let aConstraint = PredicateConstraint(predicate: aPredicate, error: FakeError.Invalid);

        let bPredicate = FakePredicate(expected: 1)
        let bConstraint = PredicateConstraint(predicate: bPredicate, error: FakeError.FailingCondition);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)

        // When
        let expect = expectation(description: "Evaluate all async")
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.valid, result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_2() {
        // Given
        let aPredicate = FakePredicate(expected: 1)
        let aConstraint = PredicateConstraint(predicate: aPredicate, error: FakeError.Invalid);

        let bPredicate = FakePredicate(expected: 2)
        let bConstraint = PredicateConstraint(predicate: bPredicate, error: FakeError.FailingCondition);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)

        // When
        let expect = expectation(description: "Evaluate all async")
        let summary = Result.Summary(errors: [FakeError.FailingCondition])
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.invalid(summary), result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_3() {

        // Given
        let aPredicate = FakePredicate(expected: 2)
        let aConstraint = PredicateConstraint(predicate: aPredicate, error: FakeError.Invalid);

        let bPredicate = FakePredicate(expected: 2)
        let bConstraint = PredicateConstraint(predicate: bPredicate, error: FakeError.FailingCondition);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)

        // When

        let expect = expectation(description: "Evaluate all async")
        let summary = Result.Summary(errors: [FakeError.Invalid, FakeError.FailingCondition])
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.invalid(summary), result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
