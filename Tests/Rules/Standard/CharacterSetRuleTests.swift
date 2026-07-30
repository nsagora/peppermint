import XCTest
import Peppermint

class CharacterSetRuleTests: XCTestCase {
    
    func testEvaluateShouldReturnTrueWhenInputHasUppercaseLettersInStrictMode() {
        let sut = CharacterSetRule(.uppercaseLetters)
        let result = sut.evaluate(with: "ABCD")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputHasLowercaseLettersInStrictMode() {
        let sut = CharacterSetRule(.uppercaseLetters)
        let result = sut.evaluate(with: "abcd")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputHasALowercaseLetterInStrictMode() {
        let sut = CharacterSetRule(.uppercaseLetters, mode: .strict)
        let result = sut.evaluate(with: "Abcd")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputHasALowercaseLetterInLooseMode() {
        let sut = CharacterSetRule(.uppercaseLetters, mode: .inclusive)
        let result = sut.evaluate(with: "Abcd")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputHasNoUppercaseLetterInLooseMode() {
        let sut = CharacterSetRule(.uppercaseLetters, mode: .inclusive)
        let result = sut.evaluate(with: "abcd")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsEmptyLetterInLooseMode() {
        let sut = CharacterSetRule(.uppercaseLetters, mode: .inclusive)
        let result = sut.evaluate(with: "")
        
        XCTAssertFalse(result)
    }
}

extension CharacterSetRuleTests {
    
    func testDynamicLookupExtension() {
        let sut: CharacterSetRule = .characterSet(.uppercaseLetters)
        let result = sut.evaluate(with: "ABCD")
        
        XCTAssertTrue(result)
    }
}
