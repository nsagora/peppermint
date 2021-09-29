import XCTest
import Peppermint

class EmailPredicateTests: XCTestCase {
    
    func testEvaluateShouldReturnFalseWhenEmailIsIncomplete() {
        let sut = EmailPredicate()
        let result = sut.evaluate(with: "test@")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenEmailIsInvalid() {
        let sut = EmailPredicate()
        let result = sut.evaluate(with: "test@example.com@example.com")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenEmailIsValid() {
        let sut = EmailPredicate()
        let result = sut.evaluate(with: "test@example.com")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnTrueWhenEmailContainsUTF8Characters() {
        let sut = EmailPredicate()
        let result = sut.evaluate(with: "tést@example.com")
        
        XCTAssertTrue(result)
    }
}

extension EmailPredicateTests {
    
    func testDynamicLookupExtension() {
        let sut: EmailPredicate = .email
        let result = sut.evaluate(with: "test@example.com")
        
        XCTAssertTrue(result)
    }
}
