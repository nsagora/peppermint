import XCTest
@testable import Peppermint

class ConstraintBuilderTests: XCTestCase {
    
    func testItCanBuildWithBlock() {
        
        let varBool = false
        let varInt = 2
        
        @ConstraintBuilder<String, FakeError> var constraints: [AnyConstraint<String, FakeError>] {
            PredicateConstraint(.required(), error: .Ordered(1))
            PredicateConstraint(.required(), error: .Ordered(2))
            
            BlockConstraint {
                $0.count == 6
            } errorBuilder: {
                .Ordered(3)
            }
            
            if varBool == false {
                PredicateConstraint(.required(), error: .Ordered(4))
                PredicateConstraint(.required(), error: .Ordered(5))
                PredicateConstraint(.required(), error: .Ordered(6))
            }
            else {
                PredicateConstraint(.required(), error: .Ordered(-1))
            }
            
            if varBool == true {
                PredicateConstraint(.required(), error: .Ordered(-1))
            }
            else {
                PredicateConstraint(.required(), error: .Ordered(7))
                PredicateConstraint(.required(), error: .Ordered(8))
            }
            
            for _ in 1...3 {
                PredicateConstraint(.required(), error: .Ordered(9))
            }
            
            if varInt % 2 == 0 {
                PredicateConstraint(.required(), error: .Ordered(10))
            }
            
            if varInt % 3 == 0 {
                PredicateConstraint(.required(), error: .Ordered(-1))
            }
            
            if #available(*) {
                PredicateConstraint(.required(), error: .Ordered(11))
            }
            else {
                PredicateConstraint(.required(), error: .Ordered(-1))
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
