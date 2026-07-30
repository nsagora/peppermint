import Foundation

/**
 The `RequiredRule` struct is used to evaluate whether a given input is empty.
 
 ```swift
 let rule = RequiredRule<String>()
 let isValid = rule.evaluate(with: "")
 ```
 */
public struct RequiredRule<T: Collection>: Rule {
    
    public typealias InputType = T
    
    private let rule = RangeRule(min: 1)
    
    /**
     Returns a new `RequiredRule` instance.
    
     ```swift
     let rule = RequiredRule<String>()
     let isValid = rule.evaluate(with: "")
     ```
     */
    public init() { }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is empty.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `false` if input is empty, otherwise `true`.
     */
    public func evaluate(with input: T) -> Bool {
        
        return rule.evaluate(with: input.count)
    }
}

// MARK: - Dynamic Lookup Extension

extension Rule {
    
    /**
     Returns a new `RequiredRule` instance.
     
     ```swift
     let rule: RequiredRule<String> = .required
     let isValid = rule.evaluate(with: "")
     ```
     */
    public static func `required`<T>() -> Self where Self == RequiredRule<T> {
        RequiredRule<T>()
    }
}
