import Foundation

/**
 The `PairMatchingPredicate` class is used to evaluate whether a given pair of values match.
 */
public class PairMatchingPredicate<T:Equatable>: Predicate {
    
    public typealias InputType = (T?, T?)
    
    /**
     Creates and returns a new `PairMatchingPredicate` instance.
     */
    public init() { }
    
    /**
     Returns a `Boolean` value that indicates whether a given pair of values match.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if the values in the pair match, otherwise `false`.
     */
    public func evaluate(with input: InputType) -> Bool {
        return input.0 == input.1
    }
}
