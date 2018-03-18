import XCTest
import ValidationToolkit

class AsyncPredicateTests: XCTestCase {
    
    func testThatAnyPredicateIsAnAsyncPredicate() {
        let predicate = FakePredicate(expected: "test")
        let evalExpectation = expectation(description: "It is evaluated async")

        predicate.evaluate(with: "test") { _ in
            evalExpectation.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
