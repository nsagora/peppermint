import XCTest
import Peppermint

class EmailRuleTests: XCTestCase {
    
    func testEvaluateShouldReturnFalseWhenEmailIsIncomplete() {
        let sut = EmailRule()
        let result = sut.evaluate(with: "test@")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenEmailIsInvalid() {
        let sut = EmailRule()
        let result = sut.evaluate(with: "test@example.com@example.com")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenEmailIsValid() {
        let sut = EmailRule()
        let result = sut.evaluate(with: "test@example.com")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnTrueWhenEmailContainsUTF8Characters() {
        let sut = EmailRule()
        let result = sut.evaluate(with: "tést@example.com")
        
        XCTAssertTrue(result)
    }
}

extension EmailRuleTests {
    
    func testDynamicLookupExtension() {
        let sut: EmailRule = .email
        let result = sut.evaluate(with: "test@example.com")
        
        XCTAssertTrue(result)
    }
}
