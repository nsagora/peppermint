import XCTest
import Peppermint

class RegexPredicateTests: XCTestCase {

    func testItFailsValidationForInvalidInput() {
        let sut = RegexPredicate(expression: "^[0-9]$")
        let result = sut.evaluate(with: "NaN")
        
        XCTAssertFalse(result)
    }
    
    func testItValidatesCaseInsensitive() {
        let sut = RegexPredicate(expression: "^Case Insensitive$")
        let result = sut.evaluate(with: "case insensitive")
        
        XCTAssertFalse(result)
    }

    func testItFailsValidationForLongInvalidInput() {
        let sut = RegexPredicate(expression: "^[0-9]$")
        let result = sut.evaluate(with: "0123456789")
        
        XCTAssertFalse(result)
    }

    func testItPassValidationForValidInput() {
        let sut = RegexPredicate(expression: "^[0-9]$")
        let result = sut.evaluate(with: "1")
        
        XCTAssertTrue(result)
    }

    func testItPassValidationWithUTF8Chars() {
        let sut = RegexPredicate(expression: "^\\p{L}$")
        let result = sut.evaluate(with: "é")
        
        XCTAssertTrue(result)
    }

    func testItPassValidationWithUTF16Chars() {
        let sut = RegexPredicate(expression: "^\\p{L}$")
        let result = sut.evaluate(with: "ߘ")
        
        XCTAssertTrue(result)
    }

    func testItPassValidationWithMandarineChars() {
        let sut = RegexPredicate(expression: "^\\p{L}+$")
        let result = sut.evaluate(with: "我")
        
        XCTAssertTrue(result)
    }
}

extension RegexPredicateTests {
    
    func testDynamicLookupExtension() {
        let sut: RegexPredicate = .regex("^[0-9]$")
        let result = sut.evaluate(with: "1")
        
        XCTAssertTrue(result)
    }
}
