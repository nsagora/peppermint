import XCTest
@testable import ValidationToolkit

class TypeConstraintTests: XCTestCase {
    
    struct FakeData {
        var integer: Int
        var string: String
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenThereIsOneKeyPathConstraintFulfilled() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        
        var sut = TypeConstraint<FakeData>()
        sut.set(integerConstraint, for:\.integer)
        
        let result = sut.evaluate(with: input)
        
        XCTAssertEqual(result, .success)
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenThereAreTwoKeyPathConstraintsFulfilled() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(predicate: BlockPredicate { $0 == "Swift"}, error: FakeError.Invalid)
        
        var sut = TypeConstraint<FakeData>()
        sut.set(integerConstraint, for:\.integer)
        sut.set(stringConstraint, for: \.string)
        
        let result = sut.evaluate(with: input)
        
        XCTAssertEqual(result, .success)
    }
    
    func testEvaluateShouldReturnAFailureResultWhenThereIsOneKeyPathConstraintFailing() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 < 5}, error: FakeError.FailingCondition)
        
        var sut = TypeConstraint<FakeData>()
        sut.set(integerConstraint, for:\.integer)
        
        let result = sut.evaluate(with: input)
        
        let summary = Result.Summary(errors: [FakeError.FailingCondition])
        XCTAssertEqual(result, Result.failure(summary))
    }
    
    func testEvaluateShouldReturnAFailureResultWhenThereAreOneFulfilledAndOneFailingKeyPathConstraints() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(predicate: BlockPredicate { $0 != "Swift"}, error: FakeError.Invalid)
        
        var sut = TypeConstraint<FakeData>()
        sut.set(integerConstraint, for:\.integer)
        sut.set(stringConstraint, for: \.string)
        
        let result = sut.evaluate(with: input)
        
        let summary = Result.Summary(errors: [FakeError.Invalid])
        XCTAssertEqual(result, .failure(summary))
    }
    
    func testEvaluateShouldReturnAFailureResultWhenThereAreTwoKeyPathConstraintsFailing() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(predicate: BlockPredicate { $0 < 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(predicate: BlockPredicate { $0 != "Swift"}, error: FakeError.Invalid)
        
        var sut = TypeConstraint<FakeData>()
        sut.set(integerConstraint, for:\.integer)
        sut.set(stringConstraint, for: \.string)
        
        let result = sut.evaluate(with: input)
        
        let summary = Result.Summary(errors: [FakeError.FailingCondition, FakeError.Invalid])
        XCTAssertEqual(result, .failure(summary))
    }
}
