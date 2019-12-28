import Foundation

/**
 A generic collection of `Constraints` on which an input can be validated on.
 */
public struct OrCompoundConstraint<T>: Constraint {
    
    public typealias InputType = T
    
    var constraints: [AnyConstraint<T>]

    /**
     Returns the number of constraints in collection
    */
    public var count: Int { constraints.count }
    
    /**
     Create a new `AndCompoundConstraint` instance populated with a predefined list of `Constraints`
     
     - parameter constraints: `[Constraint]`
     */
    public init<C: Constraint>(constraints: [C]) where C.InputType == T {
        self.constraints = constraints.map { $0.erase() }
    }
    
    /**
     Evaluates the input on all `Constraints` until the first fails.
     
     - parameter with: The input to be validated.
     - returns: `.success` if the input is valid, `.failure` containing the `Error` registered with the failing `Constraint` otherwise.
     */
    public func evaluate(with input: T) -> ValidationResult {
        
        return constraints.reduce(.success) { $0.isFailed ? $0 : $1.evaluate(with: input) }
    }
}
