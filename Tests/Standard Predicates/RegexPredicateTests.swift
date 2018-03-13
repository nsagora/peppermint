import XCTest
@testable import ValidationToolkit

class RegexPredicateTests: XCTestCase {

    var rule: RegexPredicate!

    override func setUp() {
        super.setUp()
        rule = RegexPredicate(expression: "^[0-9]$")
    }
    
    override func tearDown() {
        rule = nil
        super.tearDown()
    }

    func testItFailsValidationForInvalidInput() {
        let result = rule.evaluate(with: "NaN")
        XCTAssertFalse(result)
    }
    
    func testItValidatesCaseInsensitive() {
        let rule = RegexPredicate(expression: "^Case Insensitive$")
        let result = rule.evaluate(with: "case insensitive")
        
        XCTAssertFalse(result)
    }

    func testItFailsValidationForLongInvalidInput() {
        let result = rule.evaluate(with: "0123456789")
        XCTAssertFalse(result)
    }

    func testItPassValidationForValidInput() {
        let result = rule.evaluate(with: "1")
        XCTAssertTrue(result)
    }

    func testItPassValitdationWithUTF8Chars() {
        let rule = RegexPredicate(expression: "^\\p{L}$")
        let result = rule.evaluate(with: "é")
        XCTAssertTrue(result)
    }

    func testItPassValitdationWithUTF16Chars() {
        let rule = RegexPredicate(expression: "^\\p{L}$")
        let result = rule.evaluate(with: "ߘ")
        XCTAssertTrue(result)
    }

    func testItPassValidationWithMandarineChars() {
        let rule = RegexPredicate(expression: "^\\p{L}+$")
        let result = rule.evaluate(with: "我")
        XCTAssertTrue(result)
    }
}
