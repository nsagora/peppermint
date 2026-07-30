import XCTest
import Peppermint

class BlockRuleTests: XCTestCase {

    func testEvaluateShouldReturnTrueWhenInputIsValid() {
        let sut = BlockRule { $0 == "valid" }
        let result = sut.evaluate(with: "valid")
        
        XCTAssertTrue(result)
    }

    func testEvaluateShouldReturnFalseWhenInputIsInvalid() {
        let sut = BlockRule { $0 == "valid" }
        let result = sut.evaluate(with: "invalid")
        
        XCTAssertFalse(result)
    }
}

extension BlockRuleTests {
    
    func testDynamicLookupExtension() {
        let sut: BlockRule<String> = .block { $0 == "valid" }
        let result = sut.evaluate(with: "valid")
        
        XCTAssertTrue(result)
    }
}
