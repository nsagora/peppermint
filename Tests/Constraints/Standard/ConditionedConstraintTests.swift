import XCTest
@testable import ValidationToolkit

class ConditionedConstraintTests: XCTestCase {

    func testEvaluateReturnsTheErrorInTheResultWhenInputIsInvalid() {

        let predicate = FakePredicate(expected: "validInput")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Invalid)

        let actualResult = constraint.evaluate(with: "invalidInput")

        let summary = Result.Summary(errors: [FakeError.Invalid])
        let expectedResult = Result.failure(summary)
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testEvaluateReturnsTheBuiltErrorInTheResultWhenInputIsInvalid() {

        let predicate = FakePredicate(expected: "validInput")
        let constraint = ConditionedConstraint(predicate: predicate) { FakeError.Unexpected($0) }

        let actualResult = constraint.evaluate(with: "invalidInput")

        let summary = Result.Summary(errors: [FakeError.Unexpected("validInput")])
        let expectedResult = Result.failure(summary)
        XCTAssertEqual(actualResult, expectedResult)
    }

    func testAddConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        var constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        let secondPredicate = FakePredicate(expected: "003")
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 003"))

        constraint.add(condition: firstConstraint)
        XCTAssertEqual(constraint.conditionsCount, 1)

        constraint.add(condition: secondConstraint)
        XCTAssertEqual(constraint.conditionsCount, 2)
    }

    func testAddAnArrayOfConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        var constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        let secondPredicate = FakePredicate(expected: "003")
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 003"))

        constraint.add(conditions: [firstConstraint, secondConstraint])

        XCTAssertEqual(constraint.conditionsCount, 2)
    }

    func testAddAListOfConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        var constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        let secondPredicate = FakePredicate(expected: "003")
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 003"))

        constraint.add(conditions: firstConstraint, secondConstraint)

        XCTAssertEqual(constraint.conditionsCount, 2)
    }

    func testEvaluateShouldReturnAFailureResultWhenAConditionIsFailing() {

        let predicate = FakePredicate(expected: "001")
        var constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        constraint.add(condition: firstCondition)

        let result = constraint.evaluate(with: "__002__")
        let expectedResult = Result.Summary(errors: [FakeError.Unexpected("Expecting 002")])
        
        XCTAssertEqual(result, Result.failure(expectedResult))
    }

    func testEvaluateShouldReturnAFailingConditionWhenTheConditionsAreFulfilledButNotTheMainPredicate() {

        let predicate = FakePredicate(expected: "001")
        var constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        constraint.add(condition: firstCondition)

        let result = constraint.evaluate(with: "002")
        let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 001")])
        
        XCTAssertEqual(result, Result.failure(summary))
    }

    func testEvaluateShouldReturnAFailureResultWhenConditionsAreNotFulfilledAtDeeperLevels() {

        let predicate = FakePredicate(expected: "001")
        var constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "101")
        var firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 101"))

        let secondPredicate = FakePredicate(expected: "201")
        let secondCondition = ConditionedConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 201"))

        let thirdPredicate = FakePredicate(expected: "202")
        let thirdCondition = ConditionedConstraint(predicate: thirdPredicate, error: FakeError.Unexpected("Expecting 202"))

        firstCondition.add(condition:secondCondition)
        firstCondition.add(condition:thirdCondition)
        constraint.add(condition:firstCondition)

        let firstResult = constraint.evaluate(with: "001")
        let firstSummary = Result.Summary(errors: [FakeError.Unexpected("Expecting 201"), FakeError.Unexpected("Expecting 202")])
        XCTAssertEqual(firstResult, Result.failure(firstSummary))

        let secondResult = constraint.evaluate(with: "004")
        let secondSummary = Result.Summary(errors: [FakeError.Unexpected("Expecting 201"), FakeError.Unexpected("Expecting 201")])
        XCTAssertEqual(secondResult, Result.failure(secondSummary))
    }
}
