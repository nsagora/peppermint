import XCTest
import Peppermint

class URLPredicateTests: XCTestCase {

    func testThatItEvaluatesValidURLToTrue() {
        let sut = URLPredicate()
        let result = sut.evaluate(with: "http://www.url.com")
        
        XCTAssertTrue(result)
    }

    func testThatItEvaluatesInvalidURLToFalse() {
        let sut = URLPredicate()
        let result = sut.evaluate(with: "http://www.url com")
        
        XCTAssertFalse(result)
    }
}

extension URLPredicateTests {
    
    func testDynamicLookupExtension() {
        let sut: URLPredicate = .url
        let result = sut.evaluate(with: "http://www.url.com")
        
        XCTAssertTrue(result)
    }
}
