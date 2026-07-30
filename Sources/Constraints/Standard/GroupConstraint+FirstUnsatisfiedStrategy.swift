import Foundation

extension GroupConstraint {

    struct FirstUnsatisfiedStrategy<ST, SE: Error>: Strategy {

        typealias InputType = ST
        typealias ErrorType = SE

        func evaluate(constraints: [some Constraint<ST, SE>], with input: ST) -> Result<Void, Summary<SE>> {
            for constraint in constraints {
                let result = constraint.evaluate(with: input)
                if case .failure = result {
                    return result
                }
            }
            return .success
        }
    }
}
