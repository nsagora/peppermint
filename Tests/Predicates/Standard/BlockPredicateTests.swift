import XCTest
import Peppermint

class BlockPredicateTests: XCTestCase {

    var predicate: BlockPredicate<String>!

    override func setUp() {
        super.setUp()
        predicate = BlockPredicate { $0 == "valid" }
    }

    override func tearDown() {
        predicate = nil
        super.tearDown()
    }

    func testEvaluateShouldReturnTrueWhenInputIsValid() {
        let result = predicate.evaluate(with: "valid")
        XCTAssertTrue(result)
    }

    func testEvaluateShouldReturnFalseWhenInputIsInvalid() {
        let result = predicate.evaluate(with: "invalid")
        XCTAssertFalse(result)
    }
}

extension BlockPredicateTests {
    
    func testBlockPredicateDynamicLookupExtension() {
        let sut: BlockPredicate<String> = .block { $0 == "valid" }
        let result = sut.evaluate(with: "valid")
        
        XCTAssertTrue(result)
    }
}
