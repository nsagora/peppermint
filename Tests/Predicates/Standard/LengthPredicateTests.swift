import XCTest
import Peppermint

class LengthPredicateTests: XCTestCase {

    func testEvaluateShouldReturnTrueWhenInputIsEmptyForNoMinOrMax() {
        
        let sut = LengthPredicate<String>()
        let result = sut.evaluate(with: "")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsSmallerThanMin() {
        
        let sut = LengthPredicate<String>(min: 5)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputLengthIsLargerThanMin() {
        
        let sut = LengthPredicate<String>(min: 5)
        let result = sut.evaluate(with: "123456")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsLargerThanMax() {
        
        let sut = LengthPredicate<String>(max: 5)
        let result = sut.evaluate(with: "123456")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsSmallerThanMax() {
        
        let sut = LengthPredicate<String>(max: 5)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputLengthIsBetweenMinAndMaxRange() {
        
        let sut = LengthPredicate<String>(min: 5, max: 10)
        let result = sut.evaluate(with: "1234567")
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsAboveMinAndMaxRange() {
        
        let sut = LengthPredicate<String>(min: 5, max: 10)
        let result = sut.evaluate(with: "12345678910")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthIsBelowMinAndMaxRange() {
        
        let sut = LengthPredicate<String>(min: 5, max: 10)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputLengthEqualsTheUpperBoundOfAnOpenRange() {
        let sut = LengthPredicate<String>(0..<5)
        let result = sut.evaluate(with: "12345")
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputLengthEqualsTheUpperBoundOfAClosedRange() {
        let sut = LengthPredicate<String>(0...5)
        let result = sut.evaluate(with: "12345")
        
        XCTAssertTrue(result)
    }
}

extension LengthPredicateTests {
    
    func testDynamicLookupExtensionWithMinAndMax() {
        let sut: LengthPredicate<String> = .length(min: 5, max: 10)
        let result = sut.evaluate(with: "1234567")
        
        XCTAssertTrue(result)
    }
    
    func testDynamicLookupExtensionWithClosedRange() {
        let sut: LengthPredicate<String> = .length(0...5)
        let result = sut.evaluate(with: "12345")
        
        XCTAssertTrue(result)
    }
    
    func testDynamicLookupExtensionWithRange() {
        let sut: LengthPredicate<String> = .length(0..<5)
        let result = sut.evaluate(with: "1234")
        
        XCTAssertTrue(result)
    }
}
