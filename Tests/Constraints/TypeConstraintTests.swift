import XCTest
@testable import ValidationToolkit

class TypeConstraintTests: XCTestCase {
    
    struct TestData {
        var integer: Int
        var string: String
    }
    
    func testItReturnsSuccessWhenThereIsOneSuccessfulKeyPathConstraint() {
        // Arrange
        let input = TestData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        
        var validator = TypeConstraint<TestData>()
        validator.set(integerConstraint, for:\TestData.integer)
        
        // Act
        let result = validator.evaluate(with: input)
        
        // Assert
        XCTAssertEqual(result, .success)
    }
    
    func testItReturnsFailureWhenThereIsOneFailingKeyPathConstraint() {
        // Arrange
        let input = TestData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 < 5}, error: FakeError.FailingCondition)
        
        var validator = TypeConstraint<TestData>()
        validator.set(integerConstraint, for:\TestData.integer)
        
        // Act
        let result = validator.evaluate(with: input)
        
        // Assert
        let summary = Result.Summary(errors: [FakeError.FailingCondition])
        XCTAssertEqual(result, Result.failure(summary))
    }
    
    func testItReturnsSuccessWhenThereAreTwoSuccessfulKeyPathConstraints() {
        // Arrange
        let input = TestData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(predicate: BlockPredicate { $0 == "Swift"}, error: FakeError.Invalid)
        
        var validator = TypeConstraint<TestData>()
        validator.set(integerConstraint, for:\.integer)
        validator.set(stringConstraint, for: \.string)
        
        // Act
        let result = validator.evaluate(with: input)
        
        // Assert
        XCTAssertEqual(result, .success)
    }
    
    func testItReturnsFailureWhenThereAreOneSuccessfulAndOneFailingKeyPathConstraints() {
        // Arrange
        let input = TestData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(predicate: BlockPredicate { $0 != "Swift"}, error: FakeError.Invalid)
        
        var validator = TypeConstraint<TestData>()
        validator.set(integerConstraint, for:\.integer)
        validator.set(stringConstraint, for: \.string)
        
        // Act
        let result = validator.evaluate(with: input)
        
        // Assert
        let summary = Result.Summary(errors: [FakeError.Invalid])
        XCTAssertEqual(result, .failure(summary))
    }
    
    func testItReturnsFailureWhenThereAreTwoFailingKeyPathConstraints() {
        // Arrange
        let input = TestData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 < 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(predicate: BlockPredicate { $0 != "Swift"}, error: FakeError.Invalid)
        
        var validator = TypeConstraint<TestData>()
        validator.set(integerConstraint, for:\.integer)
        validator.set(stringConstraint, for: \.string)
        
        // Act
        let result = validator.evaluate(with: input)
        
        // Assert
        let summary = Result.Summary(errors: [FakeError.FailingCondition, FakeError.Invalid])
        XCTAssertEqual(result, .failure(summary))
    }
}
