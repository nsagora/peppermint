import XCTest
@testable import ValidationToolkit

class ConstraintTests: XCTestCase {

    fileprivate let validFakeInput = "fakeInput"
    fileprivate let invalidFakeInput = "~fakeInput"
    fileprivate let fakePredicate = FakePredicate(expected: "fakeInput")

    var constraint:SimpleConstraint<String>!

    override func setUp() {
        super.setUp()
        constraint = SimpleConstraint(predicate: fakePredicate, error: FakeError.Invalid)
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
        XCTAssertTrue(result.isValid)
    }

    func testThatItFailsWithErrorForInvalidInput() {

        // When
        let result = constraint.evaluate(with: invalidFakeInput)

        // Then
        XCTAssertTrue(result.isInvalid)
        XCTAssertEqual(result.summary.failingConstraints, 1)

        let expectedErrors = [FakeError.Invalid]
        let actualErrors = result.summary.errors as! [FakeError]
        XCTAssertEqual(actualErrors, expectedErrors)
    }
}

extension ConstraintTests {
    
    func testThatItDynamicallyBuildsTheValidationError() {

        // Given
        let constraint = SimpleConstraint(predicate: fakePredicate) { FakeError.Unexpected($0) }

        // When
        let result = constraint.evaluate(with: invalidFakeInput)

        // Then
        let actualErrors = result.summary.errors as! [FakeError]
        let expectedErrors = [FakeError.Unexpected(invalidFakeInput)]
        XCTAssertEqual(actualErrors, expectedErrors)
    }
}
