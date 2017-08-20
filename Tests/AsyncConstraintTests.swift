import XCTest
import ValidationToolkit

class AsyncConstraintTests: XCTestCase {

    func testCanAddAsyncPredicate() {
        
        let predicate = MockPredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error:MockError.Invalid)
        
        XCTAssertNotNil(constraint)
    }
    
    func testItCanBeInstantiatedWithErrorBlock() {
        
        let predicate = MockPredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error: { MockError.Wrong($0) })
        
        XCTAssertNotNil(constraint)
    }
    
    func testThatItCanValidate() {
        
        let predicate = MockPredicate<Int>()
        let constraint = AsyncConstraint(predicate: predicate, error:MockError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.01, handler: nil)
    }
    
    func testThatItCallsCallbackWithSucceesOnSuccess() {
        
        var predicate = MockPredicate<Int>()
        predicate.expectedResult = 10
        
        let constraint = AsyncConstraint(predicate: predicate, error:MockError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 10, queue:.main) { result in
            XCTAssertTrue(result.isValid)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.01, handler: nil)
        
    }
    
    func testThatItCallsCallbackWithErrorOnError() {
        
        var predicate = MockPredicate<Int>()
        predicate.expectedResult = 10
        
        let constraint = AsyncConstraint(predicate: predicate, error:MockError.Invalid)
        
        let expect = expectation(description: "Async Evaluation")
        constraint.evaluate(with: 1, queue:.main) { result in
            XCTAssertTrue(result.isInvalid)
            XCTAssertTrue(result.error is MockError)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 0.01, handler: nil)
        
    }
}

extension AsyncConstraintTests {
    
    enum MockError:Error {
        case Invalid
        case Wrong(Int)
    }
    
    struct MockPredicate<T:Equatable>:AsyncPredicate {

        var expectedResult:T?
        
        func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (Bool) -> Void) {
            
            queue.async {
                completionHandler(self.expectedResult == input)
            }

        }
    }
}
