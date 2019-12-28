import XCTest
@testable import ValidationToolkit

class AsyncCompoundConstraintTests: XCTestCase {
    
    var constraintSet: AsyncAndCompoundConstraint<Int>!
    
    override func setUp() {
        super.setUp()
        constraintSet = AsyncAndCompoundConstraint<Int>()
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
        let constraintSet = AsyncAndCompoundConstraint<Int>(constraints:constraints)
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 0)
    }
    
    func testItCanBeInstantiatedWithAPredefinedArrayOfConstraints() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncAndCompoundConstraint<Int>(constraints: [constraint])
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testItCanBeInstantiatedWithAUndefinedNumberOfConstraints() {
        
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncAndCompoundConstraint<Int>(constraints: constraint)
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncCompoundConstraintTests {
    
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

extension AsyncCompoundConstraintTests {
    
    func testItCanEvaluateAny_ForOneConstraint() {

        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        constraintSet.add(constraint: constraint)
        
        let expect = expectation(description: "Async Evaluation")
        constraintSet.evaluateAny(input: 1) { result in
            expect.fulfill()
            switch result {
            case .failure(_): XCTAssert(true)
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
            XCTAssertTrue(result.isFailed)
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
            XCTAssertTrue(result.isFailed)
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
            XCTAssertTrue(result.isSuccessful)
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
        constraintSet.evaluate(with: 1) { result in
            expect.fulfill()
            XCTAssertEqual(ValidationResult.success, result)
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
        let summary = ValidationResult.Summary(errors: [FakeError.FailingCondition])
        constraintSet.evaluate(with: 1) { result in
            expect.fulfill()
            XCTAssertEqual(ValidationResult.failure(summary), result)
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
        let summary = ValidationResult.Summary(errors: [FakeError.Invalid, FakeError.FailingCondition])
        constraintSet.evaluate(with : 1) { result in
            expect.fulfill()
            XCTAssertEqual(ValidationResult.failure(summary), result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
