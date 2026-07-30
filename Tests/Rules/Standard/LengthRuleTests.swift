import XCTest
import Peppermint

class LengthRuleTests: XCTestCase {

    func testEvaluateShouldReturnTrueWhenInputIsEmptyForNoMinOrMax() {
        let sut = LengthRule<String>()
        let result = sut.evaluate(with: "")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsSmallerThanMin() {
        let sut = LengthRule<String>(min: 5)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputLengthIsLargerThanMin() {
        let sut = LengthRule<String>(min: 5)
        let result = sut.evaluate(with: "123456")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsLargerThanMax() {
        let sut = LengthRule<String>(max: 5)
        let result = sut.evaluate(with: "123456")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsSmallerThanMax() {
        let sut = LengthRule<String>(max: 5)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputLengthIsBetweenMinAndMaxRange() {
        let sut = LengthRule<String>(min: 5, max: 10)
        let result = sut.evaluate(with: "1234567")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsAboveMinAndMaxRange() {
        let sut = LengthRule<String>(min: 5, max: 10)
        let result = sut.evaluate(with: "12345678910")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsBelowMinAndMaxRange() {
        let sut = LengthRule<String>(min: 5, max: 10)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthEqualsTheUpperBoundOfAnOpenRange() {
        let sut = LengthRule<String>(0..<5)
        let result = sut.evaluate(with: "12345")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputLengthEqualsTheUpperBoundOfAClosedRange() {
        let sut = LengthRule<String>(0...5)
        let result = sut.evaluate(with: "12345")
        
        XCTAssertTrue(result)
    }
}

extension LengthRuleTests {
    
    func testDynamicLookupExtensionWithMinAndMax() {
        let sut: LengthRule<String> = .length(min: 5, max: 10)
        let result = sut.evaluate(with: "1234567")
        
        XCTAssertTrue(result)
    }
    
    func testDynamicLookupExtensionWithClosedRange() {
        let sut: LengthRule<String> = .length(0...5)
        let result = sut.evaluate(with: "12345")
        
        XCTAssertTrue(result)
    }
    
    func testDynamicLookupExtensionWithRange() {
        let sut: LengthRule<String> = .length(0..<5)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertTrue(result)
    }
}
