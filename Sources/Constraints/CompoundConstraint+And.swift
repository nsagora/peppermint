import Foundation

/**
 A generic collection of `Constraints` on which an input can be validated on.
 */
public struct AndCompoundConstraint<T>: Constraint {
    
    public typealias InputType = T
    
    var constraints: [AnyConstraint<T>]

    /**
     Returns the number of constraints in collection
    */
    public var count: Int { constraints.count }
    
    init<C: Constraint>(constraints: [C]) where C.InputType == T {
        self.constraints = constraints.map { $0.erase() }
    }
    
    /**
     Evaluates the input on all `Constraints in the collection.
     
     - parameter with: The input to be validated.
     - returns: An array of `Result` elements, indicating the evaluation result of each `Constraint` in collection.
     */
    public func evaluate(with input: T) -> Result {

        let results = constraints.map{ $0.evaluate(with: input) }
        let summary = Result.Summary(evaluationResults: results)

        return Result(summary: summary)
    }
}
