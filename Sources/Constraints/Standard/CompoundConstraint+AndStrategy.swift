import Foundation

extension CompoundContraint {

    internal struct AndStrategy: Strategy {

        internal func evaluate<C: Constraint>(constraints: [C], with input: C.InputType) -> Result<Void, Summary<C.ErrorType>> {

            let errors = constraints
                .map { $0.evaluate(with: input) }
                .reduce(into: [C.ErrorType]()) {
                    switch $1 {
                    case .success: $0 += []
                    case .failure(let summary): $0 += summary.errors
                    }
                }
            
            let summary = Summary<C.ErrorType>(errors: errors)
            if summary.errors.isEmpty {
                return Result<Void, Summary<C.ErrorType>>.success(())
            }
            return Result<Void, Summary<C.ErrorType>>.failure(summary)
        }
    }
}
