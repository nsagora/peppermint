import XCTest
@testable import Peppermint

class TypeConstraintTests: XCTestCase {
    
    struct FakeData {
        var integer: Int
        var string: String
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenThereIsOneKeyPathConstraintFulfilled() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        
        var sut = TypeConstraint<FakeData, FakeError>()
        sut.set(for: \.integer, constraint: integerConstraint)
        
        let result = sut.evaluate(with: input)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenThereAreTwoKeyPathConstraintsFulfilled() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(BlockPredicate { $0 == "Swift"}, error: FakeError.Invalid)
        
        var sut = TypeConstraint<FakeData, FakeError>()
        sut.set(for: \.integer, constraint: integerConstraint)
        sut.set(for: \.string, constraint: stringConstraint)
        
        let result = sut.evaluate(with: input)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenThereAreTwoKeyPathConstraintsWithCnstraintBlockFulfilled() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(BlockPredicate { $0 == "Swift"}, error: FakeError.Invalid)
        
        var sut = TypeConstraint<FakeData, FakeError>()
        sut.set(for: \.integer) { integerConstraint }
        sut.set(for: \.string) { stringConstraint }
        
        let result = sut.evaluate(with: input)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenThereIsOneKeyPathConstraintFailing() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(BlockPredicate { $0 < 5}, error: FakeError.FailingCondition)
        
        var sut = TypeConstraint<FakeData, FakeError>()
        sut.set(for: \.integer, constraint: integerConstraint)
        
        let result = sut.evaluate(with: input)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.FailingCondition]))
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenThereAreOneFulfilledAndOneFailingKeyPathConstraints() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(BlockPredicate { $0 > 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(BlockPredicate { $0 != "Swift"}, error: FakeError.Invalid)
        
        var sut = TypeConstraint<FakeData, FakeError>()
        sut.set(for: \.integer, constraint: integerConstraint)
        sut.set(for: \.string, constraint: stringConstraint)
        
        let result = sut.evaluate(with: input)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenThereAreTwoKeyPathConstraintsFailing() {
        
        let input = FakeData(integer: 10, string: "Swift")
        let integerConstraint = PredicateConstraint(BlockPredicate { $0 < 5}, error: FakeError.FailingCondition)
        let stringConstraint = PredicateConstraint(BlockPredicate { $0 != "Swift"}, error: FakeError.Invalid)
        
        var sut = TypeConstraint<FakeData, FakeError>()
        sut.set(for: \.integer, constraint: integerConstraint)
        sut.set(for: \.string, constraint: stringConstraint)
        
        let result = sut.evaluate(with: input)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.FailingCondition, .Invalid]))
        default:  XCTFail()
        }
    }
}

extension TypeConstraintTests {
    
    func testItCanBeInitializedWithAConstraintsBuilder() {
        let input = FakeData(integer: 10, string: "Swift")
        
        let sut = TypeConstraint<FakeData, FakeError> {
            KeyPathConstraint(\.integer) {
                PredicateConstraint {
                    $0 < 5
                } errorBuilder: {
                    .FailingCondition
                }
            }
            
            KeyPathConstraint(\.string) {
                PredicateConstraint{
                    $0 != "Swift"
                } errorBuilder: {
                    .Invalid
                }
            }
        }
        
        let result = sut.evaluate(with: input)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.FailingCondition, .Invalid]))
        default:  XCTFail()
        }
    }
}
