import Foundation

extension CompoundContraint {
    
   internal  struct AndStrategy: Strategy {
        
        internal func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result<Void, Summary> {
            let results = constraints.map{ $0.evaluate(with: input) }
            let summary = Summary(evaluationResults: results)
            
            return Result(summary: summary)
        }
    }
}

