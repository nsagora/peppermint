import XCTest
@testable import Peppermint

class GroupConstraintTests: XCTestCase {
    
    fileprivate let validInput = "validInput"
    fileprivate let invalidInput = "~invalidInput"
}

// MARK: - allSatisfied (AND exhaustive)

extension GroupConstraintTests {
    
    func testAllSatisfiedShouldReturnAnInstanceWithAnArrayOfConstraints() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint<String, FakeError>(constraints: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testAllSatisfiedShouldReturnAnInstanceWithAListArrayOfConstraints() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint(.allSatisfied, constraints: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testAllSatisfiedShouldSucceedWhenAllConstraintsPass() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.allSatisfied, constraints: [firstConstraint, secondConstraint])
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success: XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testAllSatisfiedShouldCollectAllErrorsWhenAllConstraintsFail() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.allSatisfied, constraints: [firstConstraint, secondConstraint])
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid, .MissingInput]))
        default: XCTFail()
        }
    }
}

// MARK: - anySatisfied (OR)

extension GroupConstraintTests {
    
    func testAnySatisfiedShouldReturnAnInstanceWithAnArrayOfConstraints() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint(.anySatisfied, constraints: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testAnySatisfiedShouldSucceedWhenAllConstraintsPass() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.anySatisfied, constraints: [firstConstraint, secondConstraint])
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success: XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testAnySatisfiedShouldSucceedWhenAtLeastOneConstraintPasses() {
        let passingConstraint = BlockConstraint<String, FakeError>(
            { _ in true }, errorBuilder: { .Invalid }
        )
        let failingConstraint = BlockConstraint<String, FakeError>(
            { _ in false }, errorBuilder: { .MissingInput }
        )
        
        let sut = GroupConstraint(.anySatisfied, constraints: [failingConstraint, passingConstraint])
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success: XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testAnySatisfiedShouldCollectAllErrorsWhenAllConstraintsFail() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.anySatisfied, constraints: [firstConstraint, secondConstraint])
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid, .MissingInput]))
        default: XCTFail()
        }
    }
}

// MARK: - firstUnsatisfied (AND fail-fast)

extension GroupConstraintTests {
    
    func testFirstUnsatisfiedShouldReturnAnInstanceWithAnArrayOfConstraints() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint(.firstUnsatisfied, constraints: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testFirstUnsatisfiedShouldSucceedWhenAllConstraintsPass() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.firstUnsatisfied, constraints: [firstConstraint, secondConstraint])
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success: XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testFirstUnsatisfiedShouldReturnOnlyTheFirstErrorWhenAConstraintFails() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.firstUnsatisfied, constraints: [firstConstraint, secondConstraint])
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default: XCTFail()
        }
    }
}

extension GroupConstraintTests {
    
    func testItCanBeInitializedWithAConstraintsBuilder() {
        let sut = GroupConstraint<String, FakeError> {
            PredicateConstraint {
                RequiredPredicate()
            } errorBuilder: {
                .Invalid
            }
            BlockConstraint {
                $0 == self.validInput
            } errorBuilder: {
                .Unexpected($0)
            }
        }
        
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
}
