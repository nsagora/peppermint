import XCTest
import ValidationToolkit

class RangePredicateTests: XCTestCase {

    func testEvaluateShouldReturnTrueWhenNoMinOrMaxAvailable() {
        
        let sut = RangePredicate<Int>()
        let result = sut.evaluate(with: 10)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsSmallerThanMin() {
        
        let sut = RangePredicate(min: 10)
        let result = sut.evaluate(with: 5)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsLargerThanMin() {
        
        let sut = RangePredicate(min: 10)
        let result = sut.evaluate(with: 15)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsLargerThanMax() {
        
        let sut = RangePredicate(max: 10)
        let result = sut.evaluate(with: 15)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsSmallerThanMax() {
        
        let sut = RangePredicate(max: 10)
        let result = sut.evaluate(with: 5)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsInMinAndMaxRange() {
        
        let sut = RangePredicate(min: 5, max: 10)
        let result = sut.evaluate(with: 7)
        
        XCTAssertTrue(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsAboveMinAndMaxRange() {
        
        let sut = RangePredicate(min: 5, max: 10)
        let result = sut.evaluate(with: 15)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsBelowMinAndMaxRange() {
        
        let sut = RangePredicate(min: 5, max: 10)
        let result = sut.evaluate(with: 0)
        
        XCTAssertFalse(result)
    }
    
    func testEvaluateShouldReturnTrueWhenInputIsInTheRange() {
        let sut = RangePredicate<Int>(0...10)
        let result = sut.evaluate(with: 10)
        
        XCTAssertTrue(result)
    }
}
