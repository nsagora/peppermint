import XCTest
@testable import Peppermint

class GroupConstraintTests: XCTestCase {
    
    fileprivate let validInput = "validInput"
    fileprivate let invalidInput = "~invalidInput"
}

extension GroupConstraintTests {
    
    func testAllOfShouldReturnAnInstanceWithAnArrayOfConstrains() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint<String, FakeError>(constraints: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testAllOfShouldReturnAnInstanceWithAListArrayOfConstrains() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint(constraints: constraint)
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenAllOfTheContraintsAreFulfilled() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(constraints: firstConstraint, secondConstraint)
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenAllOfTheConstraintsAreFailing() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(constraints: firstConstraint, secondConstraint)
        let result = sut.evaluate(with: invalidInput)
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid, .MissingInput]))
        default: XCTFail()
        }
    }
}

extension GroupConstraintTests {
    
    func testAnyOfShouldReturnAnInstanceWithAnArrayOfConstrains() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint(.any, constraints: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testAnyOfShouldReturnAnInstanceWithAListOfConstrains() {
        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        
        let sut = GroupConstraint(.any, constraints: constraint)
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenAnyOfTheContraintsAreFulfilled() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.any, constraints: firstConstraint, secondConstraint)
        let result = sut.evaluate(with: validInput)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
    
    func testEvaluateShouldReturnAFailureResultWhenAnyOfTheConstraintsAreFailing() {
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate, error: FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate, error: FakeError.MissingInput)
        
        let sut = GroupConstraint(.any, constraints: firstConstraint, secondConstraint)
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

// MARK: - Dynamic Lookup Extension

extension GroupConstraintTests {
    
    func testDynamicLookupExtensionWithResultBuilder() {
        let sut: GroupConstraint<String, FakeError> = .group {
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
