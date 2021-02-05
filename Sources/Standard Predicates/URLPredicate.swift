import Foundation

/**
 The `URLPredicate` struct is used to evaluate whether a given input is a syntactically valid URL.
 */
public struct URLPredicate: Predicate {
    
    public typealias InputType = String
    
    /**
     Creates and returns a new `URLPredicate` instance.
     */
    public init() { }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is a valid URL.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input is a valid URL, otherwise `false`.
     */
    public func evaluate(with input: InputType) -> Bool {
        return URL(string: input) != nil
    }
}
