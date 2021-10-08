import Foundation

/**
 The `RequiredPredicate` struct is used to evaluate whether a given input is empty.
 
 ```swift
 let predicate = RequiredPredicate<String>()
 let isValid = predicate.evaluate(with: "")
 ```
 */
public struct RequiredPredicate<T: Collection>: Predicate {
    
    public typealias InputType = T
    
    private let predicate = RangePredicate(min: 1)
    
    /**
     Returns a new `RequiredPredicate` instance.
    
     ```swift
     let predicate = RequiredPredicate<String>()
     let isValid = predicate.evaluate(with: "")
     ```
     */
    public init() { }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is empty.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `false` if input is empty, otherwise `true`.
     */
    public func evaluate(with input: T) -> Bool {
        
        return predicate.evaluate(with: input.count)
    }
}

// MARK: - Dynamic Lookup Extension

extension Predicate {
    
    /**
     Returns a new `RequiredPredicate` instance.
     
     ```swift
     let predicate: RequiredPredicate<String> = .required
     let isValid = predicate.evaluate(with: "")
     ```
     */
    public static func `required`<T>() -> Self where Self == RequiredPredicate<T> {
        RequiredPredicate<T>()
    }
}
