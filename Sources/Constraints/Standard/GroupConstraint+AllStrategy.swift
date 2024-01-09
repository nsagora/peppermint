import Foundation

extension GroupConstraint {
    
    struct AllStrategy<ST, SE: Error>: Strategy {
        
        typealias InputType = ST
        typealias ErrorType = SE
        
        func evaluate(constraints: [some Constraint<ST, SE>], with input: ST) -> Result<Void, Summary<SE>> {
            
            let errors = constraints
                .map { $0.evaluate(with: input) }
                .reduce(into: [SE]()) {
                    switch $1 {
                    case .success: $0 += []
                    case .failure(let summary): $0 += summary.errors
                    }
                }
            if errors.isEmpty {
                return .success
            }
            return .failure(errors)
        }
    }
}
