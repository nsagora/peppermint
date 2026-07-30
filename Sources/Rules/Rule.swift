import Foundation

/**
The `Rule` protocol defines the structure that must be implemented by concrete rules.
 
 ```swift
 public struct CopyCatRule: Rule {

     private let value: String

     public init(value: String) {
         self.value = value
     }

     public func evaluate(with input: String) -> Bool {
         return input == value
     }
 }

 let rule = CopyCatRule(value: "alphabet")
 let isIdentical = rule.evaluate(with: "alphabet")
 ```
 */
public protocol Rule<InputType> {

    /// A type that provides information about what kind of values the rule can be evaluated with.
    associatedtype InputType
    
    /**
     Returns a `Boolean` value that indicates whether a given input matches the conditions specified by the receiver.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input matches the conditions specified by the receiver, `false` otherwise.
     */
    func evaluate(with input: InputType) -> Bool
}
