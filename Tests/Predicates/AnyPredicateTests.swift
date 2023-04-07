import XCTest
import Peppermint

final class AnyPredicateTests: XCTestCase {

    let predicate = BlockPredicate<Int> { $0 == 2 }

    func testItCanEraseAGivenPredicate() {
        let sut = predicate.erase()
        let result = sut.evaluate(with: 2)
        
        XCTAssertTrue(result)
    }
}
