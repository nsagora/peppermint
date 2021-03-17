import XCTest
import ValidationToolkit

class CharacterSetPredicateTests: XCTestCase {

    func testEvaluateShouldReturnTrueWhenInputHasUppercaseLettersInStrictMode() {
                
        let sut = CharacterSetPredicate(.uppercaseLetters)
        let result = sut.evaluate(with: "ABCD")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputHasLowercaseLettersInStrictMode() {
                
        let sut = CharacterSetPredicate(.uppercaseLetters)
        let result = sut.evaluate(with: "abcd")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputHasALowercaseLetterInStrictMode() {
                
        let sut = CharacterSetPredicate(.uppercaseLetters, mode: .strict)
        let result = sut.evaluate(with: "Abcd")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputHasALowercaseLetterInLooseMode() {
                
        let sut = CharacterSetPredicate(.uppercaseLetters, mode: .loose)
        let result = sut.evaluate(with: "Abcd")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputHasNoUppercaseLetterInLooseMode() {
                
        let sut = CharacterSetPredicate(.uppercaseLetters, mode: .loose)
        let result = sut.evaluate(with: "abcd")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsEmptyLetterInLooseMode() {
                
        let sut = CharacterSetPredicate(.uppercaseLetters, mode: .loose)
        let result = sut.evaluate(with: "")
        
        XCTAssertFalse(result)
    }
}
