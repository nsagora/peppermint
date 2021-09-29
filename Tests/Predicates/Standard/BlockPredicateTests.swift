import XCTest
import Peppermint

class BlockPredicateTests: XCTestCase {

    func testEvaluateShouldReturnTrueWhenInputIsValid() {
        let sut = BlockPredicate { $0 == "valid" }
        let result = sut.evaluate(with: "valid")
        
        XCTAssertTrue(result)
    }

    func testEvaluateShouldReturnFalseWhenInputIsInvalid() {
        let sut = BlockPredicate { $0 == "valid" }
        let result = sut.evaluate(with: "invalid")
        
        XCTAssertFalse(result)
    }
}

extension BlockPredicateTests {
    
    func testDynamicLookupExtension() {
        let sut: BlockPredicate<String> = .block { $0 == "valid" }
        let result = sut.evaluate(with: "valid")
        
        XCTAssertTrue(result)
    }
}
