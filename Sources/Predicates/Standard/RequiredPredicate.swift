import Foundation

/**
 The `RequiredPredicate` struct is used to evaluate whether a given input is empty.
 */
public struct RequiredPredicate<T: Collection>: Predicate {
    
    public typealias InputType = T
    
    private let predicate = RangePredicate(min: 1)
    
    /**
     Creates and returns a new `RequiredPredicate` instance.
     */
    public init() { }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is empty
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `false` if input is empty, otherwise `true`.
     */
    public func evaluate(with input: T) -> Bool {
        
        return predicate.evaluate(with: input.count)
    }
}
