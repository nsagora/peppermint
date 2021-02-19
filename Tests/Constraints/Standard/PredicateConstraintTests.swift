import XCTest
@testable import ValidationToolkit

class PredicateConstraintTests: XCTestCase {

    fileprivate let validFakeInput = "fakeInput"
    fileprivate let invalidFakeInput = "~fakeInput"
    fileprivate let fakePredicate = FakePredicate(expected: "fakeInput")

    var constraint:PredicateConstraint<String>!

    override func setUp() {
        super.setUp()
        constraint = PredicateConstraint(predicate: fakePredicate, error: FakeError.Invalid)
    }
    
    override func tearDown() {
        constraint = nil
        super.tearDown()
    }
    
    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(constraint)
    }

    func testThatItReturnsSuccessForValidInput() {
        let result = constraint.evaluate(with: validFakeInput)
        XCTAssertTrue(result.isSuccessful)
    }

    func testThatItFailsWithErrorForInvalidInput() {

        // When
        let result = constraint.evaluate(with: invalidFakeInput)

        // Then
        XCTAssertTrue(result.isFailed)
        XCTAssertEqual(result.summary.failingConstraints, 1)

        let expectedErrors = [FakeError.Invalid]
        let actualErrors = result.summary.errors as! [FakeError]
        XCTAssertEqual(actualErrors, expectedErrors)
    }
}

extension PredicateConstraintTests {
    
    func testThatItDynamicallyBuildsTheValidationError() {

        // Given
        let constraint = PredicateConstraint(predicate: fakePredicate) { FakeError.Unexpected($0) }

        // When
        let result = constraint.evaluate(with: invalidFakeInput)

        // Then
        let actualErrors = result.summary.errors as! [FakeError]
        let expectedErrors = [FakeError.Unexpected(invalidFakeInput)]
        XCTAssertEqual(actualErrors, expectedErrors)
    }
}
