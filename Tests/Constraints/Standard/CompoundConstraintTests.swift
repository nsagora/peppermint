import XCTest
@testable import ValidationToolkit

class CompoundConstraintTests: XCTestCase {

    fileprivate let validInput = "validInput"
    fileprivate let invalidInput = "~invalidInput"
}

extension CompoundConstraintTests {

    func testAllOfShouldReturnAnInstanceWithAnArrayOfConstrains() {

        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        let sut = CompoundContraint<String>(allOf: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }

    func testAllOfShouldReturnAnInstanceWithAListArrayOfConstrains() {

        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        let sut = CompoundContraint<String>(allOf: constraint)
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenAllOfTheContraintsAreFulfilled() {
        
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        
        let sut = CompoundContraint<String>(allOf: firstConstraint, secondConstraint)
        let result = sut.evaluate(with: validInput)
        
        XCTAssertEqual(result, Result.success)
    }

    func testEvaluateShouldReturnAFailureResultWhenAllOfTheContraintsAreFailing() {
        
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        
        let sut = CompoundContraint<String>(allOf: firstConstraint, secondConstraint)
        let result = sut.evaluate(with: invalidInput)
        
        let expectedResult = Result.Summary(errors: [FakeError.Invalid, FakeError.MissingInput])
        XCTAssertEqual(result, Result.failure(expectedResult))
    }
}

extension CompoundConstraintTests {
    
    func testAnyOfShouldReturnAnInstanceWithAnArrayOfConstrains() {

        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        let sut = CompoundContraint<String>(anyOf: [constraint])
        
        XCTAssertEqual(sut.count, 1)
    }

    func testAnyOfShouldReturnAnInstanceWithAListOfConstrains() {

        let predicate = FakePredicate(expected: validInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        let sut = CompoundContraint<String>(anyOf: constraint)
        
        XCTAssertEqual(sut.count, 1)
    }
    
    func testEvaluateShouldReturnASuccessfulResultWhenAnyOfTheContraintsAreFulfilled() {
        
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        
        let sut = CompoundContraint<String>(anyOf: firstConstraint, secondConstraint)
        let result = sut.evaluate(with: validInput)
        
        XCTAssertEqual(result, Result.success)
    }
    
    
    
    func testEvaluateShouldReturnAFailureResultWhenAnyOfTheContraintsAreFailing() {
        
        let predicate = FakePredicate(expected: validInput)
        let firstConstraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        let secondConstraint = PredicateConstraint(predicate: predicate, error:FakeError.MissingInput)
        
        let sut = CompoundContraint<String>(anyOf: firstConstraint, secondConstraint)
        let result = sut.evaluate(with: invalidInput)
        
        let expectedResult = Result.Summary(errors: [FakeError.Invalid])
        XCTAssertEqual(result, Result.failure(expectedResult))
    }
}
