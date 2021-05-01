import XCTest
@testable import Peppermint

class ConstraintBuilderTests: XCTestCase {
    
    func testItCanBuildWithBlock() {
        
        let varBool = false
        let varInt = 2
        
        @ConstraintBuilder<String, FakeError> var constraints: [AnyConstraint<String, FakeError>] {
            PredicateConstraint(RequiredPredicate(), error: .Ordered(1))
            PredicateConstraint(RequiredPredicate(), error: .Ordered(2))
            
            BlockConstraint {
                $0.count == 6
            } errorBuilder: {
                .Ordered(3)
            }
            
            if varBool == false {
                PredicateConstraint(RequiredPredicate(), error: .Ordered(4))
                PredicateConstraint(RequiredPredicate(), error: .Ordered(5))
                PredicateConstraint(RequiredPredicate(), error: .Ordered(6))
            }
            else {
                PredicateConstraint(RequiredPredicate(), error: .Ordered(7))
                PredicateConstraint(RequiredPredicate(), error: .Ordered(8))
            }
            
            for _ in 1...3 {
                PredicateConstraint(RequiredPredicate(), error: .Ordered(9))
            }
            
            if varInt % 2 == 0 {
                PredicateConstraint(RequiredPredicate(), error: .Ordered(10))
            }
        }
        
        let sut = CompoundConstraint<String, FakeError>(constraints: constraints)
        
        let result = sut.evaluate(with: "")
        let expected = Summary<FakeError>(errors: [
            .Ordered(1),
            .Ordered(2),
            .Ordered(3),
            .Ordered(4),
            .Ordered(5),
            .Ordered(6),
            .Ordered(9),
            .Ordered(9),
            .Ordered(9),
            .Ordered(10),
        ])
        
        switch result {
        case .failure(let summary):
            XCTAssertEqual(expected, summary)
        default: XCTFail()
        }
    }
}
