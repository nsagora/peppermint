import XCTest
import Peppermint

class RegexRuleTests: XCTestCase {

    func testItFailsValidationForInvalidInput() {
        let sut = RegexRule(expression: "^[0-9]$")
        let result = sut.evaluate(with: "NaN")
        
        XCTAssertFalse(result)
    }
    
    func testItValidatesCaseInsensitive() {
        let sut = RegexRule(expression: "^Case Insensitive$")
        let result = sut.evaluate(with: "case insensitive")
        
        XCTAssertFalse(result)
    }

    func testItFailsValidationForLongInvalidInput() {
        let sut = RegexRule(expression: "^[0-9]$")
        let result = sut.evaluate(with: "0123456789")
        
        XCTAssertFalse(result)
    }

    func testItPassValidationForValidInput() {
        let sut = RegexRule(expression: "^[0-9]$")
        let result = sut.evaluate(with: "1")
        
        XCTAssertTrue(result)
    }

    func testItPassValidationWithUTF8Chars() {
        let sut = RegexRule(expression: "^\\p{L}$")
        let result = sut.evaluate(with: "é")
        
        XCTAssertTrue(result)
    }

    func testItPassValidationWithUTF16Chars() {
        let sut = RegexRule(expression: "^\\p{L}$")
        let result = sut.evaluate(with: "ߘ")
        
        XCTAssertTrue(result)
    }

    func testItPassValidationWithMandarineChars() {
        let sut = RegexRule(expression: "^\\p{L}+$")
        let result = sut.evaluate(with: "我")
        
        XCTAssertTrue(result)
    }
}

extension RegexRuleTests {
    
    func testDynamicLookupExtension() {
        let sut: RegexRule = .regex("^[0-9]$")
        let result = sut.evaluate(with: "1")
        
        XCTAssertTrue(result)
    }
}
