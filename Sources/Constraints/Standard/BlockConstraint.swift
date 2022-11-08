import Foundation

/**
 A `Constraint` that links a custom validation closure to an `Error` that describes why the evaluation has failed.
 
 ```swift
 enum Failure: Error {
     case notEven
 }
 ```
 
 ```swift
 let constraint = BlockConstraint<Int, Failure> {
     $0 % 2 == 0
 } errorBuilder: {
     .notEven
 }
 let result = constraint.evaluate(with: 2)
 ```
 */
public struct BlockConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let predicate: BlockPredicate<T>
    private let errorBuilder: (T) -> E
    
    /**
     Returns a new `BlockConstraint` instance.
     
     ```swift
     enum Failure: Error {
         case notEven
     }
     ```
     
     ```swift
     let constraint = BlockConstraint<Int, Failure> {
         $0 % 2 == 0
     } errorBuilder: {
         .notEven
     }
     let result = constraint.evaluate(with: 2)
     ```
     
     - parameter evaluationBlock: A closure describing a custom validation condition.
     - parameter errorBuilder: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ evaluationBlock: @escaping (T) -> Bool, errorBuilder: @escaping () -> E) {
        self.predicate = BlockPredicate(evaluationBlock: evaluationBlock)
        self.errorBuilder = { _ in errorBuilder() }
    }
    
    /**
     Create a new `BlockConstraint` instance.
     
     ```swift
     enum Failure: Error {
         case notEven(Int)
     }
     ```
     
     ```swift
     let constraint = BlockConstraint<Int, Failure> {
         $0 % 2 == 0
     } errorBuilder: { input in
         .notEven(input)
     }
     let result = constraint.evaluate(with: 2)
     ```
     
     - parameter evaluationBlock: A closure describing a custom validation condition.
     - parameter errorBuilder: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ evaluationBlock: @escaping (T) -> Bool, errorBuilder: @escaping (T) -> E) {
        predicate = BlockPredicate(evaluationBlock: evaluationBlock)
        self.errorBuilder = errorBuilder
    }
    
    /**
     Evaluates the input against the provided evaluation closure.
     
     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        let result = predicate.evaluate(with: input)
        
        if result == true {
            return .success
        }
        
        let error = errorBuilder(input)
        return .failure(error)
    }
}
