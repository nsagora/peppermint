import XCTest
@testable import ValidationToolkit

class AsyncCompoundConstraintTests: XCTestCase {
    
    func testItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        
        // Arrange
        let constraints = [AnyAsyncConstraint<Int>]()
        
        // Act
        let sut = CompoundAsyncConstraint.and(subconstraints: constraints)
        
        // Assert
        XCTAssertEqual(sut.count, 0)
    }
    
    func testItCanBeInstantiatedWithAPredefinedArrayOfConstraints() {
        
        // Arrange
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid);
        
        // Act
        let sut = CompoundAsyncConstraint.and(subconstraints: [constraint])
        
        // Assert
        XCTAssertEqual(sut.count, 1)
    }
    
    func testItCanBeInstantiatedWithAUndefinedNumberOfConstraints() {
        
        // Arrange
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid);
        
        // Act
        let constraintSet = CompoundAsyncConstraint.and(subconstraints: constraint)
        
        
        // Assert
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension AsyncCompoundConstraintTests {
    
    func testItCanEvaluateAny_ForOneConstraint() {
        
        // Arrange
        let predicate = FakePredicate(expected: 10)
        let constraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        let sut = CompoundAsyncConstraint.or(subconstraints: constraint)
        
        let expect = expectation(description: "Async Evaluation")
        
        // Act
        sut.evaluate(with: 1) { result in
            
            // Assert
            expect.fulfill()
            switch result {
            case .failure(_): XCTAssert(true)
            default: XCTFail()
            }
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint() {
        
        // Arrange
        let predicate = FakePredicate(expected: 10)
        let firstConstraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error: FakeError.MissingInput)
        let sut = CompoundAsyncConstraint.or(subconstraints: firstConstraint, secondConstraint)
        
        let expect = expectation(description: "Async Evaluation")
        
        // Act
        sut.evaluate(with: 1) { result in
            expect.fulfill()
            
            // Assert
            XCTAssertTrue(result.isFailed)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint2() {
        
        // Arrange
        let predicate = FakePredicate(expected: 10)
        let firstConstraint = PredicateConstraint(predicate: predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error: FakeError.MissingInput)
        let sut = CompoundAsyncConstraint.or(subconstraints: firstConstraint, secondConstraint)
        
        let expect = expectation(description: "Async Evaluation")
        
        // Act
        sut.evaluate(with: 20) { result in
            expect.fulfill()
            
            // Assert
            XCTAssertTrue(result.isFailed)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAny_ForTwoConstraint3() {
        
        // Arrange
        let firstPredicate = FakePredicate(expected: 20)
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Invalid);
        
        let secondPredicate = FakePredicate(expected: 20)
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Invalid);
        
        let sut = CompoundAsyncConstraint.or(subconstraints: firstConstraint, secondConstraint)
        
        let expect = expectation(description: "Asyn Evaluation")
        
        // Act
        sut.evaluate(with: 20) { result in
            expect.fulfill()
            
            // Assert
            XCTAssertTrue(result.isSuccessful)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAll_ToValid() {
        
        // Arrange
        let firstPredicate = FakePredicate(expected: 1)
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Invalid);
        
        let secondPredicate = FakePredicate(expected: 1)
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Invalid);
        
        let sut = CompoundAsyncConstraint.and(subconstraints: firstConstraint, secondConstraint)
        
        let expect = expectation(description: "Evaluate all async")
        
        // Act
        sut.evaluate(with: 1) { result in
            expect.fulfill()
            
            // Assert
            XCTAssertEqual(ValidationResult.success, result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAll_ToValid_2() {
        // Arrange
        let firstPredicate = FakePredicate(expected: 1)
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Invalid);
        
        let secondPredicate = FakePredicate(expected: 2)
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.FailingCondition);
        
        let sut = CompoundAsyncConstraint.and(subconstraints: firstConstraint, secondConstraint)
        
        let expect = expectation(description: "Evaluate all async")
        let summary = ValidationResult.Summary(errors: [FakeError.FailingCondition])
        
        // Act
        sut.evaluate(with: 1) { result in
            expect.fulfill()
            
            // Assert
            XCTAssertEqual(ValidationResult.failure(summary), result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testItCanEvaluateAll_ToValid_3() {
        
        // Arrange
        let firstPredicate = FakePredicate(expected: 2)
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Invalid);
        
        let secondPredicate = FakePredicate(expected: 2)
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.FailingCondition);
        
        let sut = CompoundAsyncConstraint.and(subconstraints: firstConstraint, secondConstraint)
        
        let expect = expectation(description: "Evaluate all async")
        let summary = ValidationResult.Summary(errors: [FakeError.Invalid, FakeError.FailingCondition])
        
        // Act
        sut.evaluate(with : 1) { result in
            expect.fulfill()
            
            // Assert
            XCTAssertEqual(ValidationResult.failure(summary), result)
        }
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
