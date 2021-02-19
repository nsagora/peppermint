import XCTest
import ValidationToolkit

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
