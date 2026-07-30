import XCTest
import Peppermint

class RangeRuleTests: XCTestCase {
    
    func testEvaluateShouldReturnTrueWhenNoMinOrMaxAvailable() {
        let sut = RangeRule<Int>()
        let result = sut.evaluate(with: 10)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsSmallerThanMin() {
        let sut = RangeRule(min: 10)
        let result = sut.evaluate(with: 5)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsLargerThanMin() {
        let sut = RangeRule(min: 10)
        let result = sut.evaluate(with: 15)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsLargerThanMax() {
        let sut = RangeRule(max: 10)
        let result = sut.evaluate(with: 15)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsSmallerThanMax() {
        let sut = RangeRule(max: 10)
        let result = sut.evaluate(with: 5)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsInMinAndMaxRange() {
        let sut = RangeRule(min: 5, max: 10)
        let result = sut.evaluate(with: 7)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsAboveMinAndMaxRange() {
        let sut = RangeRule(min: 5, max: 10)
        let result = sut.evaluate(with: 15)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsBelowMinAndMaxRange() {
        let sut = RangeRule(min: 5, max: 10)
        let result = sut.evaluate(with: 0)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFakeWhenInputEqualsTheUpperBoundOfTheOpenRange() {
        let sut = RangeRule<Int>(0..<10)
        let result = sut.evaluate(with: 10)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsInTheRange() {
        let sut = RangeRule<Int>(0...10)
        let result = sut.evaluate(with: 10)
        
        XCTAssertTrue(result)
    }
}


extension RangeRuleTests {
    
    func testDynamicLookupExtensionWithMinAndMax() {
        let sut: RangeRule = .range(min: 5, max: 10)
        let result = sut.evaluate(with: 7)
        
        XCTAssertTrue(result)
    }
    
    func testDynamicLookupExtensionWithClosedRange() {
        let sut: RangeRule = .range(0...10)
        let result = sut.evaluate(with: 10)
        
        XCTAssertTrue(result)
    }
    
    func testDynamicLookupExtensionWithRange() {
        let sut: RangeRule = .range(0..<10)
        let result = sut.evaluate(with: 10)
        
        XCTAssertFalse(result)
    }
}
