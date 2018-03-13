import XCTest
@testable import ValidationToolkit

class ConditionedConstraintTests: XCTestCase {

    func testThatCanAppendConditionalConstraints() {

        // Arrange
        let predicate_001 = FakePredicate(expected: "001")
        let constraint_001 = ConditionedConstraint(predicate: predicate_001, error: FakeError.Unexpected("Expecting 001"))

        let predicate_002 = FakePredicate(expected: "002")
        let constraint_002 = SimpleConstraint(predicate: predicate_002, error: FakeError.Unexpected("Expecting 002"))

        let predicate_003 = FakePredicate(expected: "003")
        let constraint_003 = SimpleConstraint(predicate: predicate_003, error: FakeError.Unexpected("Expecting 003"))

        // Assert
        constraint_001.append(condition:constraint_002)
        XCTAssertEqual(constraint_001.conditionsCount, 1)

        constraint_001.append(condition:constraint_003)
        XCTAssertEqual(constraint_001.conditionsCount, 2)
    }

    func testThatItDoentEvaluateWhenHavingAFailingCondition() {

        // Arrange
        let predicate = FakePredicate(expected: "001")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        constraint.append(condition:firstCondition)

        // Act
        let result = constraint.evaluate(with: "__002__")
        let expectedResult = Result.Summary(errors: [FakeError.Unexpected("Expecting 002")])

        // Assert
        XCTAssertEqual(result, Result.invalid(expectedResult))
    }

    func testThatItEvaluateWhenHavingAValidCondition() {

        // Arrange
        let predicate = FakePredicate(expected: "001")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        constraint.append(condition:firstCondition)

        // Act
        let result = constraint.evaluate(with: "002")
        let summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 001")])

        // Assert
        XCTAssertEqual(result, Result.invalid(summary))
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition() {

        // Arrange
        let predicate = FakePredicate(expected: "001")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "101")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 101"))

        let secondPredicate = FakePredicate(expected: "201")
        let secondCondition = ConditionedConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 201"))

        let thirdPredicate = FakePredicate(expected: "202")
        let thirdCondition = ConditionedConstraint(predicate: thirdPredicate, error: FakeError.Unexpected("Expecting 202"))

        firstCondition.append(condition:secondCondition)
        firstCondition.append(condition:thirdCondition)
        constraint.append(condition:firstCondition)

        var result = constraint.evaluate(with: "001")
        var summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 201"), FakeError.Unexpected("Expecting 202")])
        XCTAssertEqual(result, Result.invalid(summary))

        result = constraint.evaluate(with: "004")
        summary = Result.Summary(errors: [FakeError.Unexpected("Expecting 201"), FakeError.Unexpected("Expecting 201")])
        XCTAssertEqual(result, Result.invalid(summary))
    }
}
