import Foundation

/**
 A type-erased `Constraint`.
 
 ```swift
 enum Failure: Error {
     case notEven
 }
 
 let constraint = BlockConstraint<Int, Failure> {
     $0 % 2 == 0
 } errorBuilder: {
     .notEven
 }
 
 let anyConstraint = AnyConstraint(constraint)
 anyConstraint.evaluate(with: 3)
 ```
 */
public struct AnyConstraint<T, E: Error>: Constraint {

    public typealias InputType = T
    public typealias ErrorType = E

    private let constraint: any Constraint<T, E>

    /**
     Creates a type-erased `Constraint` that wraps the given instance.
     */
    public init<C: Constraint>(_ constraint: C) where C.InputType == T, C.ErrorType == E {
        self.constraint = constraint
    }

    /**
     Evaluates the input against the receiver.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        return constraint.evaluate(with: input)
    }
}

extension Constraint {

    /**
     Wraps this constraint with a type eraser.
     
     ```swift
     enum Failure: Error {
         case notEven
     }
     
     let constraint = BlockConstraint<Int, Failure> {
         $0 % 2 == 0
     } errorBuilder: {
         .notEven
     }
     
     var erasedConstraint = constraint.erase()
     erasedConstraint.evaluate(with: 5)
     ```
     
     - Returns: An `AnyConstraint` wrapping this constraint.
     */
    public func erase() -> AnyConstraint<InputType, ErrorType> {
        return AnyConstraint(self)
    }
}
