import XCTest
@testable import ValidationToolkit

class ConstraintTests: XCTestCase {

    fileprivate let fakeInput = "testInput"
    fileprivate let fakePredicate = FakePredicate(expected: "testInput")

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
        let result = constraint.evaluate(with: fakeInput)
        XCTAssertTrue(result.isValid)
    }

    func testThatItFailsWithErrorForInvalidInput() {
        let result = constraint.evaluate(with: "Ok")
        XCTAssertEqual(result.errors as! [FakeError], [FakeError.Invalid])
    }
}

extension ConstraintTests {
    
    func testThatItDynamicallyBuildsTheValidationError() {
        let constraint = SimpleConstraint(predicate: fakePredicate) { FakeError.Unexpected($0) }
        let result = constraint.evaluate(with: "Ok")

        XCTAssertEqual(result.errors as! [FakeError], [FakeError.Unexpected("Ok")])
    }
}

// MARK: - Fakes

extension ConstraintTests {
    
    fileprivate enum FakeError: FakeableError {
        case Invalid
        case Unexpected(String)
    }
    
    fileprivate struct FakePredicate: Predicate  {
        
        var expected: String
        
        func evaluate(with input: String) -> Bool {
            return input == expected
        }
    }
}
