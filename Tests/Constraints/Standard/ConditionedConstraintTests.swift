import XCTest
@testable import ValidationToolkit

class ConditionedConstraintTests: XCTestCase {

    func testEvaluateReturnsTheErrorInTheResultWhenInputIsInvalid() {

        let predicate = FakePredicate(expected: "validInput")
        let sut = ConditionedConstraint(predicate: predicate, error: FakeError.Invalid)

        let result = sut.evaluate(with: "invalidInput")

        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Invalid]))
        default:
            XCTFail()
        }
    }
    
    func testEvaluateReturnsTheBuiltErrorInTheResultWhenInputIsInvalid() {

        let predicate = FakePredicate(expected: "validInput")
        let sut = ConditionedConstraint(predicate: predicate) { FakeError.Unexpected($0) }

        let result = sut.evaluate(with: "invalidInput")
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("validInput")]))
        default:
            XCTFail()
        }
    }

    func testAddConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        var sut = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        let secondPredicate = FakePredicate(expected: "003")
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 003"))

        sut.add(condition: firstConstraint)
        XCTAssertEqual(sut.conditionsCount, 1)

        sut.add(condition: secondConstraint)
        XCTAssertEqual(sut.conditionsCount, 2)
    }

    func testAddAnArrayOfConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        var sut = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        let secondPredicate = FakePredicate(expected: "003")
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 003"))

        sut.add(conditions: [firstConstraint, secondConstraint])

        XCTAssertEqual(sut.conditionsCount, 2)
    }

    func testAddAListOfConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        var sut = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstConstraint = PredicateConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        let secondPredicate = FakePredicate(expected: "003")
        let secondConstraint = PredicateConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 003"))

        sut.add(conditions: firstConstraint, secondConstraint)

        XCTAssertEqual(sut.conditionsCount, 2)
    }

    func testEvaluateShouldReturnAFailureResultWhenAConditionIsFailing() {

        let predicate = FakePredicate(expected: "001")
        var sut = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        sut.add(condition: firstCondition)

        let result = sut.evaluate(with: "__002__")
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("Expecting 002")]))
        default:
            XCTFail()
        }
    }

    func testEvaluateShouldReturnAFailingConditionWhenTheConditionsAreFulfilledButNotTheMainPredicate() {

        let predicate = FakePredicate(expected: "001")
        var sut = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "002")
        let firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 002"))

        sut.add(condition: firstCondition)

        let result = sut.evaluate(with: "002")
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("Expecting 001")]))
        default:
            XCTFail()
        }
    }

    func testEvaluateShouldReturnAFailureResultWhenConditionsAreNotFulfilledAtDeeperLevels() {

        let predicate = FakePredicate(expected: "001")
        var sut = ConditionedConstraint(predicate: predicate, error: FakeError.Unexpected("Expecting 001"))

        let firstPredicate = FakePredicate(expected: "101")
        var firstCondition = ConditionedConstraint(predicate: firstPredicate, error: FakeError.Unexpected("Expecting 101"))

        let secondPredicate = FakePredicate(expected: "201")
        let secondCondition = ConditionedConstraint(predicate: secondPredicate, error: FakeError.Unexpected("Expecting 201"))

        let thirdPredicate = FakePredicate(expected: "202")
        let thirdCondition = ConditionedConstraint(predicate: thirdPredicate, error: FakeError.Unexpected("Expecting 202"))

        firstCondition.add(condition:secondCondition)
        firstCondition.add(condition:thirdCondition)
        sut.add(condition:firstCondition)

        let firstResult = sut.evaluate(with: "001")
        
        switch firstResult {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("Expecting 201"), .Unexpected("Expecting 202")]))
        default:
            XCTFail()
        }

        let secondResult = sut.evaluate(with: "004")
        
        switch secondResult {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("Expecting 201"), .Unexpected("Expecting 201")]))
        default:
            XCTFail()
        }
    }
}
