import XCTest
@testable import Peppermint

class KeyPathConstraintTests: XCTestCase {
    
    struct FakeData {
        var integer: Int
        var string: String
    }
    
    func testDynamicLookupExtension() {
        let data = FakeData(integer: 10, string: "ten")
        let sut: KeyPathConstraint<FakeData, Int, FakeError> = .keyPath(\.integer) {
            .block {
                $0 == 10
            } errorBuilder: {
                .Invalid
            }
        }
        
        let result = sut.evaluate(with: data)
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default: XCTFail()
        }
    }
}
