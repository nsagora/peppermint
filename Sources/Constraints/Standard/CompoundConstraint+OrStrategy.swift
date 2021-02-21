import Foundation

extension CompoundContraint {
    
    internal struct OrStrategy: Strategy {
        
        internal func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result<Void, Summary<C.ErrorType>> {
            return constraints.reduce(.success(())) { $0.isFailure ? $0 : $1.evaluate(with: input) }
        }
    }
}

