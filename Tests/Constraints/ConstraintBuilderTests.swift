import XCTest
@testable import Peppermint

class ConstraintBuilderTests: XCTestCase {
    
    func testItCanBuildWithBlock() {
        
        let varBool = false
        let varInt = 2
        
        @ConstraintBuilder<String, FakeError> var constraints: [AnyConstraint<String, FakeError>] {
            RequiredConstraint { .Ordered(1) }
            RequiredConstraint { .Ordered(2) }
            
            BlockConstraint {
                $0.count == 6
            } errorBuilder: {
                .Ordered(3)
            }
            
            if varBool == false {
                RequiredConstraint { .Ordered(4) }
                RequiredConstraint { .Ordered(5) }
                RequiredConstraint { .Ordered(6) }
            }
            else {
                RequiredConstraint { .Ordered(-1) }
            }
            
            if varBool == true {
                RequiredConstraint { .Ordered(-1) }
            }
            else {
                RequiredConstraint { .Ordered(7) }
                RequiredConstraint { .Ordered(8)}
            }
            
            for _ in 1...3 {
                RequiredConstraint { .Ordered(9) }
            }
            
            if varInt % 2 == 0 {
                RequiredConstraint { .Ordered(10) }
            }
            
            if varInt % 3 == 0 {
                RequiredConstraint { .Ordered(-1) }
            }
            
            if #available(*) {
                RequiredConstraint { .Ordered(11) }
            }
            else {
                RequiredConstraint { .Ordered(-1) }
            }
        }
        
        let sut = GroupConstraint<String, FakeError>(constraints: constraints)
        
        let result = sut.evaluate(with: "")
        let expected = Summary<FakeError>(errors: [
            .Ordered(1),
            .Ordered(2),
            .Ordered(3),
            .Ordered(4),
            .Ordered(5),
            .Ordered(6),
            .Ordered(7),
            .Ordered(8),
            .Ordered(9),
            .Ordered(9),
            .Ordered(9),
            .Ordered(10),
            .Ordered(11),
        ])
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(expected, summary)
        default: XCTFail()
        }
    }
}
