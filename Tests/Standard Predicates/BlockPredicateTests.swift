import XCTest
@testable import ValidationToolkit

class BlockPredicateTests: XCTestCase {

    var predicate: BlockPredicate<Int>!

    override func setUp() {
        super.setUp()
        predicate = BlockPredicate { $0 == 2 }
    }
    
    override func tearDown() {
        predicate = nil
        super.tearDown()
    }

    func testThatItEvaluatesTrueForValidInput() {
        let result = predicate.evaluate(with: 2)
        XCTAssertTrue(result)
    }

    func testThatItEvaluatesFalseForInvalidInput() {
        let result = predicate.evaluate(with: 1)
        XCTAssertFalse(result)
    }
}
