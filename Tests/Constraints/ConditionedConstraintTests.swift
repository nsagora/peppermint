import XCTest
@testable import ValidationToolkit

class ConditionedConstraintTests: XCTestCase {

    private var constraint:ConditionedConstraint<String>!
    private let fakePredicate = FakePredicate(expected: "testInput")

    override func setUp() {
        super.setUp()
        constraint = ConditionedConstraint(predicate: fakePredicate, error: FakeError.Failing)
    }

    override func tearDown() {
        constraint = nil
        super.tearDown()
    }

    func testAddConditions() {

        // Arrange
        let predicate = FakePredicate(expected: "001")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Failing("001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Failing("002"))

        let secondPredicate = FakePredicate(expected: "003")
        let secondConstraint = ConditionedConstraint(predicate: secondPredicate, error: FakeError.Failing("003"))

        // Assert
        constraint.append(condition:firstCondition)
        XCTAssertEqual(constraint.conditionsCount, 1)

        constraint.append(condition:secondConstraint)
        XCTAssertEqual(constraint.conditionsCount, 2)
    }

    func testThatItDoentEvaluateWhenHavingAFailingCondition() {

        // Arrange
        let predicate = FakePredicate(expected: "001")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Failing("001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Failing("002"))

        constraint.append(condition:firstCondition)

        // Act
        let result = constraint.evaluate(with: "__002")
        let expectedResult = Result.Summary(errors: [FakeError.Failing("002")])

        // Assert
        XCTAssertEqual(result, Result.invalid(expectedResult))
    }

    func testThatItEvaluateWhenHavingAValidCondition() {

        // Arrange
        let predicate = FakePredicate(expected: "001")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Failing("001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Failing("002"))

        constraint.append(condition:firstCondition)

        // Act
        let result = constraint.evaluate(with: "002")
        let summary = Result.Summary(errors: [FakeError.Failing("001")])

        // Assert
        XCTAssertEqual(result, Result.invalid(summary))
    }

    func testThatItEvaluateWhenHavingMultiLevelCondition() {

        // Arrange
        let predicate = FakePredicate(expected: "001")
        let constraint = ConditionedConstraint(predicate: predicate, error: FakeError.Failing("001"))

        let firstPredicate = FakePredicate(expected: "101")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Failing("101"))

        let secondPredicate = FakePredicate(expected: "201")
        let secondCondition = ConditionedConstraint(predicate: secondPredicate, error: FakeError.Failing("201"))

        let thirdPredicate = FakePredicate(expected: "202")
        let thirdCondition = ConditionedConstraint(predicate: thirdPredicate, error: FakeError.Failing("Expecting 003"))

        firstCondition.append(condition:secondCondition)
        firstCondition.append(condition:thirdCondition)
        constraint.append(condition:firstCondition)

        var result = constraint.evaluate(with: "001")
        var summary = Result.Summary(errors: [FakeError.Failing("Expecting 002"), FakeError.Failing("Expecting 003")])
        XCTAssertEqual(result, Result.invalid(summary))

        result = constraint.evaluate(with: "004")
        summary = Result.Summary(errors: [FakeError.Failing("Expecting 002"), FakeError.Failing("Expecting 003")])
        XCTAssertEqual(result, Result.invalid(summary))
    }
}

// MARK: - Fakes

extension ConditionedConstraintTests {

    fileprivate enum FakeError: FakeableError {
        case Failing(String)
    }

    fileprivate struct FakePredicate: Predicate  {

        var expected: String

        func evaluate(with input: String) -> Bool {
            return input == expected
        }
    }
}
