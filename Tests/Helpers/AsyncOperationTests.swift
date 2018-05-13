import XCTest
@testable import ValidationToolkit

class AsyncOperationTests: XCTestCase {
    
    func testThatIsAsyncronous() {

        // Given
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)

        // When
        let operation = AsyncConstraintSet<Int>.AsyncOperation(input: 10, constraint:constraint.erase())

        // Then
        XCTAssertTrue(operation.isAsynchronous)
    }

    func testThatIsReadyWhenInitialised() {

        // Given
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        
        // When
        let operation = AsyncConstraintSet<Int>.AsyncOperation(input: 10, constraint:constraint.erase())

        // Then
        XCTAssertTrue(operation.isReady)
    }

    func testThatIsMarkedAsCanceledWhenIsCanceledBeforeStarting() {

        // Given
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        let operation = AsyncConstraintSet<Int>.AsyncOperation(input: 10, constraint:constraint.erase())

        let queue = OperationQueue()
        queue.isSuspended = true
        queue.addOperation(operation)

        // When
        queue.cancelAllOperations()

        // Then
        XCTAssertTrue(operation.isCancelled)
    }

    func testThatIsExecuting() {

        // Given
        var isExecuting = false

        let constraint = TestableAsyncConstraint<Int>()
        let operation = AsyncConstraintSet<Int>.AsyncOperation(input: 10, constraint:constraint.erase())

        let queue = OperationQueue()
        queue.isSuspended = true
        queue.addOperation(operation)

        let expect = expectation(description: "The async operation is executing")
        constraint.block = {
            isExecuting = operation.isExecuting
            expect.fulfill()
        }

        // When
        queue.isSuspended = false
        waitForExpectations(timeout: 0.5, handler: nil)

        // Then
        XCTAssertTrue(isExecuting)
    }

    func testThatIsMarkedAsFinishedWhenCancelled() {

        // Given
        let constraint = TestableAsyncConstraint<Int>()
        let operation = AsyncConstraintSet<Int>.AsyncOperation(input: 10, constraint:constraint.erase())
        operation.cancel()

        // When
        operation.start()

        // Then
        XCTAssertTrue(operation.isFinished)
    }
}
