import XCTest
@testable import ValidationToolkit

class AsyncConstraintSetTests: XCTestCase {
    
    var constraintSet: AsyncConstraintSet<Int>!
    
    override func setUp() {
        super.setUp()
        constraintSet = AsyncConstraintSet<Int>()
    }
    
    func testItCanBeInstantiated() {
    
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 0)
    }
    
    func testItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        
        let constraintSet = AsyncConstraintSet<Int>(constraints: [])
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 0)
    }
    
    func testItCanBeInstantiatedWithAPredefinedArrayOfConstraints() {
        
        let predicate = FakePredicate(10)
        let constraint = AsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncConstraintSet<Int>(constraints: [constraint])
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testItCanBeInstantiatedWithAUndefinedNumberOfConstraints() {
        
        let predicate = FakePredicate(10)
        let constraint = AsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraintSet = AsyncConstraintSet<Int>(constraints: constraint)
        XCTAssertNotNil(constraintSet)
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanAddAnAsynConstraint() {
        
        let predicate = FakePredicate(10)
        let constraint = AsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        constraintSet.add(constraint: constraint)
        
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testItCanAddMultipleAsyncConstraints() {
        
        let aPredicate = FakePredicate(10)
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: FakeError.Invalid);
        
        let bPredicate = FakePredicate(10)
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: FakeError.Invalid);

        constraintSet.add(constraint: aConstraint)
        constraintSet.add(constraint: bConstraint)
        
        XCTAssertEqual(constraintSet.count, 2)
    }
    
    func testItCanAddAConstraintUsingAlternativeMethod() {
        
        let predicate = FakePredicate(10)
        constraintSet.add(predicate: predicate, error:FakeError.Invalid)
        
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanEvaluateAny_ForOneConstraint() {

        constraintSet.add(predicate: FakePredicate(10), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 1) { result in
            expect.fulfill()
            switch result {
            case .invalid(_): XCTAssert(true)
            default: XCTFail()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint() {
        constraintSet.add(predicate: FakePredicate(10), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 1) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint2() {

        constraintSet.add(predicate: FakePredicate(10), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint3() {

        constraintSet.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraintSet.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isValid)
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testItCanEvaluateAll_ToValid() {

        constraintSet.add(predicate: FakePredicate(1), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(1), error: FakeError.FailedCondition)

        let expect = expectation(description: "Evaluate all async")
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.valid, result)
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_2() {

        constraintSet.add(predicate: FakePredicate(1), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(2), error: FakeError.FailedCondition)

        let expect = expectation(description: "Evaluate all async")
        let summary = Result.Summary(errors: [FakeError.FailedCondition])
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.invalid(summary), result)
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_3() {

        constraintSet.add(predicate: FakePredicate(2), error: FakeError.Invalid)
        constraintSet.add(predicate: FakePredicate(2), error: FakeError.FailedCondition)

        let expect = expectation(description: "Evaluate all async")
        let summary = Result.Summary(errors: [FakeError.Invalid, FakeError.FailedCondition])
        constraintSet.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(Result.invalid(summary), result)
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}

extension AsyncConstraintSetTests {
    
    enum FakeError:Error {
        case Invalid
        case FailedCondition
    }
    
    struct FakePredicate<T:Equatable>:AsyncPredicate {
        
        var expectedResult:T

        init(_ expectedResult:T) {
            self.expectedResult = expectedResult
        }

        func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (Bool) -> Void) {
            
            queue.async {
                completionHandler(self.expectedResult == input)
            }
        }
    }
}
