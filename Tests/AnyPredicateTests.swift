import XCTest
import ValidationToolkit

class AnyPredicateTests: XCTestCase {
    
    func testWeCanStoreAPredicateAsAnAnyPredicate() {

        var predicate:AnyPredicate<String>
        predicate = AnyPredicate(BlockPredicate<String> { $0.count > 0 })

        XCTAssertTrue(predicate.evaluate(with: "fakeInput"))
    }

    func testWeCanEraseAPredicate() {

        let predicate = BlockPredicate<String> { $0.count > 0 }
        let anyPredicate:AnyPredicate<String> = predicate.erase()

        XCTAssertTrue(anyPredicate.evaluate(with: "fakeInput"))
    }
}
