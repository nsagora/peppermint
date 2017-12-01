import XCTest
@testable import ValidationToolkit

class AsyncConstraintSetTests: XCTestCase {
    
    var constraints: AsyncConstraintSet<Int>!
    
    override func setUp() {
        super.setUp()
        constraints = AsyncConstraintSet<Int>()
    }
    
    func testItCanBeInstantiated() {
    
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 0)
    }
    
    func testItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        
        let constraints = AsyncConstraintSet<Int>(constraints: [])
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 0)
    }
    
    func testItCanBeInstantiatedWithAPredefinedArrayOfConstraints() {
        
        let predicate = FakePredicate(10)
        let constraint = AsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraints = AsyncConstraintSet<Int>(constraints: [constraint])
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 1)
    }
    
    func testItCanBeInstantiatedWithAUndefinedNumberOfConstraints() {
        
        let predicate = FakePredicate(10)
        let constraint = AsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        let constraints = AsyncConstraintSet<Int>(constraints: constraint)
        XCTAssertNotNil(constraints)
        XCTAssertEqual(constraints.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanAddAnAsynConstraint() {
        
        let predicate = FakePredicate(10)
        let constraint = AsyncConstraint(predicate: predicate, error: FakeError.Invalid);
        
        constraints.add(constraint: constraint)
        
        XCTAssertEqual(constraints.count, 1)
    }
    
    func testItCanAddMultipleAsyncConstraints() {
        
        let aPredicate = FakePredicate(10)
        let aConstraint = AsyncConstraint(predicate: aPredicate, error: FakeError.Invalid);
        
        let bPredicate = FakePredicate(10)
        let bConstraint = AsyncConstraint(predicate: bPredicate, error: FakeError.Invalid);

        constraints.add(constraint: aConstraint)
        constraints.add(constraint: bConstraint)
        
        XCTAssertEqual(constraints.count, 2)
    }
    
    func testItCanAddAConstraintUsingAlternativeMethod() {
        
        let predicate = FakePredicate(10)
        constraints.add(predicate: predicate, error:FakeError.Invalid)
        
        XCTAssertEqual(constraints.count, 1)
    }
}

extension AsyncConstraintSetTests {
    
    func testItCanEvaluateAny_ForOneConstraint() {

        constraints.add(predicate: FakePredicate(10), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 1) { result in
            expect.fulfill()
            switch result {
            case .invalid(_): XCTAssert(true)
            default: XCTFail()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint() {
        constraints.add(predicate: FakePredicate(10), error: FakeError.Invalid)
        constraints.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 1) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint2() {

        constraints.add(predicate: FakePredicate(10), error: FakeError.Invalid)
        constraints.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isInvalid)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint3() {

        constraints.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        constraints.add(predicate: FakePredicate(20), error: FakeError.Invalid)
        
        let expect = expectation(description: "Asyn Evaluation")
        constraints.evaluateAny(input: 20) { result in
            expect.fulfill()
            XCTAssertTrue(result.isValid)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testItCanEvaluateAll_ToValid() {

        constraints.add(predicate: FakePredicate(1), error: FakeError.Invalid)
        constraints.add(predicate: FakePredicate(1), error: FakeError.FailedCondition)

        let expect = expectation(description: "Evaluate all async")
        constraints.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(EvaluationResult.valid, result)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_2() {

        constraints.add(predicate: FakePredicate(1), error: FakeError.Invalid)
        constraints.add(predicate: FakePredicate(2), error: FakeError.FailedCondition)

        let expect = expectation(description: "Evaluate all async")
        let summary = EvaluationResult.Summary(errors: [FakeError.FailedCondition])
        constraints.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(EvaluationResult.invalid(summary), result)
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testItCanEvaluateAll_ToValid_3() {

        constraints.add(predicate: FakePredicate(2), error: FakeError.Invalid)
        constraints.add(predicate: FakePredicate(2), error: FakeError.FailedCondition)

        let expect = expectation(description: "Evaluate all async")
        let summary = EvaluationResult.Summary(errors: [FakeError.Invalid, FakeError.FailedCondition])
        constraints.evaluateAll(input: 1) { result in
            expect.fulfill()
            XCTAssertEqual(EvaluationResult.invalid(summary), result)
        }
        waitForExpectations(timeout: 1, handler: nil)
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
