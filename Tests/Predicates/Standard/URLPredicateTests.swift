import XCTest
import Peppermint

class URLPredicateTests: XCTestCase {

    var predicate: URLPredicate!

    override func setUp() {
        super.setUp()
        predicate = URLPredicate()
    }
    
    override func tearDown() {
        predicate = nil
        super.tearDown()
    }

    func testThatItEvaluatesValuidURLToTrue() {
        let result = predicate.evaluate(with: "http://www.url.com")
        XCTAssertTrue(result)
    }

    func testThatItEvaluatesInvaluidURLToFalse() {
        let result = predicate.evaluate(with: "http:\\www.url.com")
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
