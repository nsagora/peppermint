import Foundation

extension GroupConstraint {
    
    struct AnyStrategy<ST, SE: Error>: Strategy {
        
        typealias InputType = ST
        typealias ErrorType = SE
        
        func evaluate(constraints: [some Constraint<ST, SE>], with input: ST) -> Result<Void, Summary<SE>>{
            return constraints.reduce(.success) {
                switch $0 {
                case .success: return $1.evaluate(with: input)
                case .failure: return $0
                }
            }
        }
    }
}
