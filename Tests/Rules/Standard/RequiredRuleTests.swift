import XCTest
import Peppermint

class RequiredRuleTests: XCTestCase {
    
    func testEvaluateShouldReturnFalseWhenInputIsEmpty() {
        let sut = RequiredRule<String>()
        let result = sut.evaluate(with: "")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsNotEmpty() {
        let sut = RequiredRule<String>()
        let result = sut.evaluate(with: "input")
        
        XCTAssertTrue(result)
    }
}

extension RequiredRuleTests {
    
    func testDynamicLookupExtension() {
        let sut: RequiredRule<String> = .required()
        let result = sut.evaluate(with: "")
        
        XCTAssertFalse(result)
    }
}
