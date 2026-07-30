import XCTest
import Peppermint

final class AnyRuleTests: XCTestCase {

    let rule = BlockRule<Int> { $0 == 2 }

    func testItCanEraseAGivenRule() {
        let sut = rule.erase()
        let result = sut.evaluate(with: 2)
        
        XCTAssertTrue(result)
    }
}
