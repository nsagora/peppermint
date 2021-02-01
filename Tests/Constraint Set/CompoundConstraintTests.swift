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
        let sut = CompoundContraint<String>(allOf: constraints)
        
        // Assert
        XCTAssertEqual(sut.count, 0)
    }

    func testThatItCanBeInstantiatedWithAnFinitArrayofConstrains() {

        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        // Act
        let sut = CompoundContraint<String>(allOf: [constraint])
        
        // Assert
        XCTAssertEqual(sut.count, 1)
    }

    func testThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {

        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        // Act
        let sut = CompoundContraint<String>(allOf: constraint)
        
        // Assert
        XCTAssertEqual(sut.count, 1)
    }
    
    func testThatWithoutConstraints_EvaluateAll_IsValid() {
        // Arrange
        let constraints = [AnyConstraint<String>]()
        let sut = CompoundContraint<String>(allOf: constraints)
        
        // Act
        let result = sut.evaluate(with: "all")
        
        // Assert
        XCTAssertEqual(result, Result.success)
    }
    
    func testThatForValidInput_EvaluateAny_IsValid() {
        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let sut = CompoundContraint<String>(allOf: constraint)
        
        // Act
        let result = sut.evaluate(with: validFakeInput)
        
        // Assert
        XCTAssertEqual(result, Result.success)
    }
    
    func testThatForValidInput_EvaluateAll_IsValid() {
        
        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        let sut = CompoundContraint<String>(allOf: firstConstraint, secondConstraint)
        
        // Act
        let result = sut.evaluate(with: validFakeInput)
        
        // Assert
        XCTAssertEqual(result, Result.success)
    }

    func testThatForInvalidInput_EvaluateAll_IsInvalid() {
        
        // Arrange
        let expected = Result.Summary(errors: [FakeError.Invalid, FakeError.MissingInput])
        
        let predicate = FakePredicate(expected: validFakeInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        let sut = CompoundContraint<String>(allOf: firstConstraint, secondConstraint)
        
        // Act
        let result = sut.evaluate(with: invalidFakeInput)
        
        // Assert
        XCTAssertEqual(result, Result.failure(expected))
    }
}

extension CompoundConstraintTests {
    
    func testAnyOfThatItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        // Arrange
        let constraints = [AnyConstraint<String>]()
        
        // Act
        let sut = CompoundContraint<String>(anyOf: constraints)
        
        // Assert
        XCTAssertEqual(sut.count, 0)
    }

    func testAnyOfThatItCanBeInstantiatedWithAnFinitArrayofConstrains() {

        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        // Act
        let sut = CompoundContraint<String>(anyOf: [constraint])
        
        // Assert
        XCTAssertEqual(sut.count, 1)
    }

    func testAnyOfThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {

        // Arrange
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        // Act
        let sut = CompoundContraint<String>(anyOf: constraint)
        
        // Assert
        XCTAssertEqual(sut.count, 1)
    }
    
    func testThatWithoutConstraints_EvaluateAny_IsValid() {
        // Arrange
        let constraints = [AnyConstraint<String>]()
        let sut = CompoundContraint(anyOf: constraints)
        
        // Act
        let result = sut.evaluate(with: "any")
        
        // Assert
        XCTAssertEqual(result, Result.success)
    }
    
    
    
    func testThatForInvalidInput_EvaluateAny_IsInvalid() {
        
        // Arrange
        let expected = Result.Summary(errors: [FakeError.Invalid])
        
        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let sut = CompoundContraint<String>(anyOf: constraint)
        
        // Act
        let result = sut.evaluate(with: invalidFakeInput)
        
        // Assert
        XCTAssertEqual(result, Result.failure(expected))
    }
}
