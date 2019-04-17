import XCTest
@testable import ValidationToolkit

class ConstraintSetTests: XCTestCase {

    fileprivate let validFakeInput = "fakeInput"
    fileprivate let invalidFakeInput = "~fakeInput"
    fileprivate let predicate = FakePredicate(expected:"fakeInput")
    fileprivate var constraintSet: ConstraintSet<String>!
    
    override func setUp() {
        super.setUp()
        constraintSet = ConstraintSet()
    }
    
    override func tearDown() {
        constraintSet = nil
        super.tearDown()
    }
}

extension ConstraintSetTests {
    
    func testThatItCanBeInstantiated() {
        XCTAssertNotNil(constraintSet)
    }
    
    func testThatAfterInit_ItHasNoConstraints() {
        XCTAssertEqual(constraintSet.count, 0)
    }
    
    func testThatItCanBeInstantiatedWithAnEmptyArrayOfConstraints() {
        
        let constraints = [AnyConstraint<String>]()
        let constraintSet = ConstraintSet<String>(constraints:constraints)
        XCTAssertEqual(constraintSet.count, 0)
    }

    func testThatItCanBeInstantiatedWithAnFinitArrayofConstrains() {

        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        let constraintSet = ConstraintSet<String>(constraints:[constraint])
        XCTAssertEqual(constraintSet.count, 1)
    }

    func testThatItCanBeInstantiatedWithAnUnknownNumberOfConstrains() {

        let predicate = FakePredicate(expected: validFakeInput)
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)

        let constraintSet = ConstraintSet<String>(constraints:constraint)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testThatWithoutConstraints_EvaluateAny_IsValid() {
        
        let result = constraintSet.evaluateAny(input: "any")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testThatWithoutConstraints_EvaluateAll_IsValid() {
        
        let result = constraintSet.evaluateAny(input: "all")
        XCTAssertEqual(result, ValidationResult.success)
    }
}

extension ConstraintSetTests {
    
    func testThatCanAddConstraint() {
        
        let constraint = PredicateConstraint(predicate: predicate, error:FakeError.Invalid)
        
        constraintSet.add(constraint: constraint)
        XCTAssertEqual(constraintSet.count, 1)
    }
    
    func testThatCanAddConstraintUsingAlternativeMethod() {
        
        constraintSet.add(predicate: predicate, error:FakeError.Invalid)
        XCTAssertEqual(constraintSet.count, 1)
    }
}

extension ConstraintSetTests {
    
    func testThatForValidInput_EvaluateAny_IsValid() {
        
        constraintSet.add(predicate: predicate, error:FakeError.Invalid)

        let result = constraintSet.evaluateAny(input: validFakeInput)
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testThatForInvalidInput_EvaluateAny_IsInvalid() {
        
        constraintSet.add(predicate: predicate, error:FakeError.Invalid)
        
        let result = constraintSet.evaluateAny(input: invalidFakeInput)
        let summary = ValidationResult.Summary(errors: [FakeError.Invalid])
        
        XCTAssertEqual(result, ValidationResult.failure(summary))
    }
    
    func testThatForValidInput_EvaluateAll_IsValid() {
        
        constraintSet.add(predicate: predicate, error:FakeError.Invalid)
        constraintSet.add(predicate: predicate, error:FakeError.MissingInput)
        
        let result = constraintSet.evaluateAll(input: validFakeInput)
        XCTAssertEqual(result, ValidationResult.success)
    }

    func testThatForInvalidInput_EvaluateAll_IsInvalid() {

        constraintSet.add(predicate: predicate, error:FakeError.Invalid)
        constraintSet.add(predicate: predicate, error:FakeError.MissingInput)

        let result = constraintSet.evaluateAll(input: invalidFakeInput)
        let summary = ValidationResult.Summary(errors: [FakeError.Invalid, FakeError.MissingInput])
        XCTAssertEqual(result, ValidationResult.failure(summary))
    }
}
