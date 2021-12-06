import XCTest
import Peppermint

class DatePredicateTests: XCTestCase {
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter
    }()
    
    func testEvaluateShouldReturnTrueWhenInputIsValid() {
                
        let sut = DatePredicate(formatter: dateFormatter)
        
        XCTAssertTrue(sut.evaluate(with: "2021-12-06"))
    }
    
    func testEvaluateShouldReturnFalseWhenInputIsInvalid() {
        
        let sut = DatePredicate(formatter: dateFormatter)
        
        XCTAssertFalse(sut.evaluate(with: "06/12/2021"))
    }
}
