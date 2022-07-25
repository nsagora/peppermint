import Foundation

extension GroupConstraint {
    
    struct AnyStrategy<T, E: Error>: Strategy {
        
        typealias InputType = T
        typealias ErrorType = E
        
        func evaluate(constraints: [some Constraint<T, E>], with input: T) -> Result<Void, Summary<E>>{
            return constraints.reduce(.success(())) {
                switch $0 {
                case .success: return $1.evaluate(with: input)
                case .failure: return $0
                }
            }
        }
    }
}
