import Foundation

public struct OptionalConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T?
    public typealias ErrorType = E
    
    private let constraint: AnyConstraint<T, E>
    private let requiredError: E?
    
    /**
     Returns a new `OptionalConstraint` instance.
     */
    public init<C: Constraint>(required requiredError: E? = nil, constraintBuilder: () -> C) where C.InputType == T, C.ErrorType == E {
        self.init(required: requiredError, constraint: constraintBuilder())
    }
    
    /**
     Returns a new `OptionalConstraint` instance.
     */
    public init<C: Constraint>(required requiredError: E? = nil, constraint: C) where C.InputType == T, C.ErrorType == E {
        self.constraint = constraint.erase()
        self.requiredError = requiredError
    }
    
    public func evaluate(with input: T?) -> Result<Void, Summary<E>> {
        
        if let input = input {
            return constraint.evaluate(with: input)
        }
        
        if let requiredError = requiredError {
            return .failure(Summary(errors: [requiredError]))
        }
        
        return .success(())
    }
}
