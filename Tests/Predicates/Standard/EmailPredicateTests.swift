import XCTest
import Peppermint

class EmailPredicateTests: XCTestCase {

    var predicate: EmailPredicate!

    override func setUp() {
        super.setUp()
        predicate = EmailPredicate()
    }
    
    override func tearDown() {
        predicate = nil
        super.tearDown()
    }

    func testEvaluateShouldReturnFalseWhenEmailIsIncomplete() {
        let email = "test@"
        let result = predicate.evaluate(with: email)
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenEmailIsInvalid() {
        let email = "test@example.com@example.com"
        let result = predicate.evaluate(with: email)
        XCTAssertFalse(result)
    }

    func testEvaluateShouldReturnTrueWhenEmailIsValid() {
        let email = "test@example.com"
        let result = predicate.evaluate(with: email)
        XCTAssertTrue(result)
    }

    func testEvaluateShouldReturnTrueWhenEmailContainsUTF8Characters() {
        let email = "tést@example.com"
        let result = predicate.evaluate(with: email)
        XCTAssertTrue(result)
    }
}

extension EmailPredicateTests {
    
    func testDynamicLookupExtension() {
        let sut: EmailPredicate = .email
        let email = "test@example.com"
        let result = sut.evaluate(with: email)
        
        XCTAssertTrue(result)
    }
}
