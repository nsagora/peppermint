import XCTest
import Peppermint

class RequiredPredicateTests: XCTestCase {

    func testEvaluateShouldReturnFalseWhenInputIsEmpty() {
        
        let sut = RequiredPredicate<String>()
        let result = sut.evaluate(with: "")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsNotEmpty() {
        
        let sut = RequiredPredicate<String>()
        let result = sut.evaluate(with: "input")
        
        XCTAssertTrue(result)
    }
}
