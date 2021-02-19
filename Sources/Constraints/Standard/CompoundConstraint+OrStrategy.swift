import Foundation

extension CompoundContraint {
    
    internal struct OrStrategy: Strategy {
        
        internal func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result {
            return constraints.reduce(.success) { $0.isFailed ? $0 : $1.evaluate(with: input) }
        }
    }
}

