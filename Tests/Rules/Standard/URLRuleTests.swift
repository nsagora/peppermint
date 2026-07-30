import XCTest
import Peppermint

class URLRuleTests: XCTestCase {

    func testThatItEvaluatesValidURLToTrue() {
        let sut = URLRule()
        let result = sut.evaluate(with: "http://www.url.com")
        
        XCTAssertTrue(result)
    }

    func testThatItEvaluatesInvalidURLToFalse() {
        let sut = URLRule()
        let result = sut.evaluate(with: "http://www.url com")
        
        XCTAssertFalse(result)
    }
}

extension URLRuleTests {
    
    func testDynamicLookupExtension() {
        let sut: URLRule = .url
        let result = sut.evaluate(with: "http://www.url.com")
        
        XCTAssertTrue(result)
    }
}
