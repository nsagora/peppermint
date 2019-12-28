import XCTest
@testable import ValidationToolkit

class CompoundConstraintTests: XCTestCase {

    fileprivate let validFakeInput = "fakeInput"
    fileprivate let invalidFakeInput = "~fakeInput"
}

extension CompoundConstraintTests {
    
    func testThatItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        // Arrange
        let constraints = [AnyConstraint<String>]()
        
        // Act
        let sut = CompoundContraint<String>.andConstraintWith(subconstraints: constraints)
        
        // Assert
        XCTAssertEqual(sut.count, 0)
    }

    func testThatItCanBeInstantiatedWithAnFinitArrayofConstrains() {

        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        // Act
        let sut = CompoundContraint<String>.andConstraintWith(subconstraints: [constraint])
        
        // Assert
        XCTAssertEqual(sut.count, 1)
    }

    func testThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {

        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        // Act
        let sut = CompoundContraint<String>.andConstraintWith(subconstraints: constraint)
        
        // Assert
        XCTAssertEqual(sut.count, 1)
    }
    
    func testThatWithoutConstraints_EvaluateAny_IsValid() {
        // Arrange
        let constraints = [AnyConstraint<String>]()
        let sut = CompoundContraint.orConstraintWith(subconstraints: constraints)
        
        // Act
        let result = sut.evaluate(with: "any")
        
        // Assert
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testThatWithoutConstraints_EvaluateAll_IsValid() {
        // Arrange
        let constraints = [AnyConstraint<String>]()
        let sut = CompoundContraint.andConstraintWith(subconstraints: constraints)
        
        // Act
        let result = sut.evaluate(with: "all")
        
        // Assert
        XCTAssertEqual(result, ValidationResult.success)
    }
}

extension CompoundConstraintTests {
    
    func testThatForValidInput_EvaluateAny_IsValid() {
        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let sut = CompoundContraint<String>.orConstraintWith(subconstraints: constraint)
        
        // Act
        let result = sut.evaluate(with: validFakeInput)
        
        // Assert
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testThatForInvalidInput_EvaluateAny_IsInvalid() {
        
        // Arrange
        let expected = ValidationResult.Summary(errors: [FakeError.Invalid])
        
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let sut = CompoundContraint<String>.orConstraintWith(subconstraints: constraint)
        
        // Act
        let result = sut.evaluate(with: invalidFakeInput)
        
        // Assert
        XCTAssertEqual(result, ValidationResult.failure(expected))
    }
    
    func testThatForValidInput_EvaluateAll_IsValid() {
        
        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        let sut = CompoundContraint<String>.andConstraintWith(subconstraints: firstConstraint, secondConstraint)
        
        // Act
        let result = sut.evaluate(with: validFakeInput)
        
        // Assert
        XCTAssertEqual(result, ValidationResult.success)
    }

    func testThatForInvalidInput_EvaluateAll_IsInvalid() {
        
        // Arrange
        let expected = ValidationResult.Summary(errors: [FakeError.Invalid, FakeError.MissingInput])
        
        let predicate = FakePredicate(expected: validFakeInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        let sut = CompoundContraint<String>.andConstraintWith(subconstraints: firstConstraint, secondConstraint)
        
        // Act
        let result = sut.evaluate(with: invalidFakeInput)
        
        // Assert
        XCTAssertEqual(result, ValidationResult.failure(expected))
    }
}
