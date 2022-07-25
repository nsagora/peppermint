import Foundation

extension GroupConstraint {
    
    struct AllStrategy<T, E: Error>: Strategy {
        
        typealias InputType = T
        typealias ErrorType = E
        
        func evaluate(constraints: [some Constraint<T, E>], with input: T) -> Result<Void, Summary<E>> {
            
            let errors = constraints
                .map { $0.evaluate(with: input) }
                .reduce(into: [E]()) {
                    switch $1 {
                    case .success: $0 += []
                    case .failure(let summary): $0 += summary.errors
                    }
                }
            
            let summary = Summary<E>(errors: errors)
            if summary.errors.isEmpty {
                return Result<Void, Summary<E>>.success(())
            }
            
            return Result<Void, Summary<E>>.failure(summary)
        }
    }
}
