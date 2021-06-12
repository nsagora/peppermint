import Foundation

public struct BlockConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let predicate: BlockPredicate<T>
    private let errorBuilder: (T) -> E
    
    /**
     Returns a new `BlockConstraint` instance with an underlying `BlockPredicate`.
     
     - parameter evaluationBlock: A closure describing a custom validation condition.
     - parameter errorBuilder: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ evaluationBlock: @escaping (T) -> Bool, errorBuilder: @escaping () -> E) {
        self.predicate = BlockPredicate(evaluationBlock: evaluationBlock)
        self.errorBuilder = { _ in errorBuilder() }
    }
    
    /**
     Create a new `BlockConstraint` instance with an underlying `BlockPredicate`.
     
     - parameter evaluationBlock: A closure describing a custom validation condition.
     - parameter errorBuilder: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ evaluationBlock: @escaping (T) -> Bool, errorBuilder: @escaping (T) -> E) {
        predicate = BlockPredicate(evaluationBlock: evaluationBlock)
        self.errorBuilder = errorBuilder
    }
    
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        let result = predicate.evaluate(with: input)
        
        if result == true {
            return .success(())
        }
        
        let error = errorBuilder(input)
        let summary = Summary(errors: [error])
        return .failure(summary)
    }
}
