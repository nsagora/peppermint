import XCTest

@testable import ValidationToolkit

class ConditionedConstraintTests: XCTestCase {

    func testInitConditionalConstraintsWithConditions() {

        let predicate = FakePredicate(expected: "001")
        let firstPredicate = FakePredicate(expected: "002")
        let secondPredicate = FakePredicate(expected: "003")

        let sut = ConditionedConstraint<String, FakeError>(
            PredicateConstraint (predicate, error: .Unexpected("Expecting 001")),
            conditions:
                PredicateConstraint( firstPredicate, error: .Unexpected("Expecting 002")),
                PredicateConstraint(secondPredicate, error: .Unexpected("Expecting 003"))
        )

        XCTAssertEqual(sut.conditionsCount, 2)
    }

    func testAddAConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        let firstPredicate = FakePredicate(expected: "002")
        let secondPredicate = FakePredicate(expected: "003")

        var sut = ConditionedConstraint<String, FakeError>(
            PredicateConstraint(predicate, error: .Unexpected("Expecting 001")),
            conditions:
                PredicateConstraint(firstPredicate, error: .Unexpected("Expecting 002")),
                PredicateConstraint(secondPredicate, error: .Unexpected("Expecting 003"))
        )
        
        let thirdPredicate = FakePredicate(expected: "004")
        sut.add(PredicateConstraint(thirdPredicate, error: .Unexpected("Expecting 004")))

        XCTAssertEqual(sut.conditionsCount, 3)
    }
    
    func testAddAnArrayOfConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        let firstPredicate = FakePredicate(expected: "002")
        let secondPredicate = FakePredicate(expected: "003")

        var sut = ConditionedConstraint<String, FakeError>(
            PredicateConstraint(predicate, error: .Unexpected("Expecting 001")),
            conditions:
                PredicateConstraint( firstPredicate, error: .Unexpected("Expecting 002")),
                PredicateConstraint(secondPredicate, error: .Unexpected("Expecting 003"))
        )
        
        let thirdPredicate = FakePredicate(expected: "004")
        let forthPredicate = FakePredicate(expected: "005")
        sut.add([
            PredicateConstraint(thirdPredicate, error: .Unexpected("Expecting 004")),
            PredicateConstraint(forthPredicate, error: .Unexpected("Expecting 005"))
        ])

        XCTAssertEqual(sut.conditionsCount, 4)
    }

    func testAddAListOfConditionalConstraints() {

        let predicate = FakePredicate(expected: "001")
        let firstPredicate = FakePredicate(expected: "002")
        let secondPredicate = FakePredicate(expected: "003")

        var sut = ConditionedConstraint<String, FakeError>(
            PredicateConstraint(predicate, error: .Unexpected("Expecting 001")),
            conditions:
                PredicateConstraint( firstPredicate, error: .Unexpected("Expecting 002")),
                PredicateConstraint(secondPredicate, error: .Unexpected("Expecting 003"))
        )
        
        let thirdPredicate = FakePredicate(expected: "004")
        let forthPredicate = FakePredicate(expected: "005")
        sut.add(
            PredicateConstraint(thirdPredicate, error: .Unexpected("Expecting 004")),
            PredicateConstraint(forthPredicate, error: .Unexpected("Expecting 005"))
        )

        XCTAssertEqual(sut.conditionsCount, 4)
    }

    func testEvaluateShouldReturnAFailureResultWhenAConditionIsFailing() {

        let predicate = FakePredicate(expected: "001")
        let firstPredicate = FakePredicate(expected: "002")
        let secondPredicate = FakePredicate(expected: "003")

        let sut = ConditionedConstraint<String, FakeError>(
            PredicateConstraint(predicate, error: .Unexpected("Expecting 001")),
            conditions:
                PredicateConstraint( firstPredicate, error: .Unexpected("Expecting 002")),
                PredicateConstraint( secondPredicate, error: .Unexpected("Expecting 003"))
        )

        let result = sut.evaluate(with: "__002__")

        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("Expecting 002"), .Unexpected("Expecting 003")]))
        default: XCTFail()
        }
    }

    func testEvaluateShouldReturnAFailingConditionWhenTheConditionsAreFulfilledButNotTheMainPredicate() {

        let predicate = FakePredicate(expected: "001")
        let firstPredicate = FakePredicate(expected: "002")

        let sut = ConditionedConstraint<String, FakeError>(
            PredicateConstraint(predicate, error: .Unexpected("Expecting 001")),
            conditions:
                PredicateConstraint(firstPredicate, error: .Unexpected("Expecting 002"))
        )

        let result = sut.evaluate(with: "002")

        switch result {
        case .failure(let summary):
            XCTAssertEqual(summary, Summary<FakeError>(errors: [.Unexpected("Expecting 001")]))
        default: XCTFail()
        }
    }
}
