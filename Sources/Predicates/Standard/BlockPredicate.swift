import Foundation

/**
 The `BlockPredicate` struct defines a closure based condition used to evaluate generic inputs.
 
 ```swift
 let predicate = BlockPredicate<Int> {
    $0 % 2 == 0
 }
 
 let isEven = even.evaluate(with: 2)
 ```
 */
public struct BlockPredicate<T>: Predicate {
    
    public typealias InputType = T
    
    private let evaluationBlock: (InputType) -> Bool
    
    /**
     Returns a new `BlockPredicate` instance.
          
     ```swift
     let predicate = BlockPredicate<Int> {
        $0 % 2 == 0
     }
     
     let isEven = even.evaluate(with: 2)
     ```
     - parameter evaluationBlock: A closure describing a custom validation condition.
     - parameter input: The input against which to evaluate the receiver.
     
     */
    public init(evaluationBlock: @escaping (_ input: InputType) -> Bool) {
        self.evaluationBlock = evaluationBlock
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input matches the evaluation closure specified by the receiver.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input matches the validation closure specified by the receiver, otherwise `false`.
     */
    public func evaluate(with input: InputType) -> Bool {
        return evaluationBlock(input)
    }
}

// MARK: - Dynamic Lookup Extension

extension Predicate {
    
    /**
     Returns a new `BlockPredicate` instance.
          
     ```swift
     let predicate: BlockPredicate<Int> = .block {
        $0 % 2 == 0
     }
     
     let isEven = even.evaluate(with: 2)
     ```
     - parameter evaluationBlock: A closure describing a custom validation condition.
     - parameter input: The input against which to evaluate the receiver.
     */
    public static func block<T>(evaluationBlock: @escaping (_ input: T) -> Bool) -> Self where Self == BlockPredicate<T> {
        BlockPredicate(evaluationBlock: evaluationBlock)
    }
    
}
