import XCTest
import ValidationToolkit

class CharacterSetPredicateTests: XCTestCase {

    func testEvaluateShouldReturnTrueWhenInputIsAlphanumeric() {
                
        let sut = CharacterSetPredicate(.alphanumerics)
        let result = sut.evaluate(with: "abcd")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsNotAlphanumeric() {
                
        let sut = CharacterSetPredicate(.alphanumerics)
        let result = sut.evaluate(with: "#abcd")
        
        XCTAssertFalse(result)
    }
}
