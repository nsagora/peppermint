import Foundation

extension GroupConstraint {

    struct AnySatisfiedStrategy<ST, SE: Error>: Strategy {

        typealias InputType = ST
        typealias ErrorType = SE

        func evaluate(constraints: [some Constraint<ST, SE>], with input: ST) -> Result<Void, Summary<SE>> {
            var errors = [SE]()
            for constraint in constraints {
                let result = constraint.evaluate(with: input)
                switch result {
                case .success:
                    return .success
                case .failure(let summary):
                    errors += summary.errors
                }
            }
            return .failure(errors)
        }
    }
}
