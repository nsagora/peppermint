import Foundation

/**
 The `RegexPredicate` struct is used to define regular expression based conditions used to evaluate input strings.
 
 ```swift
 let predicate = RegexPredicate(expression: "^\\d+$")
 let isValid = predicate.evaluate(with: "1234567890")
 ```
 */
public struct RegexPredicate: Predicate {
    
    public typealias InputType = String
    
    private var expression: String
    
    /**
     Returns a new `RegexPredicate` instance.
     
     ```swift
     let predicate = RegexPredicate(expression: "^\\d+$")
     let isValid = predicate.evaluate(with: "1234567890")
     ```
     
     - parameter expression: A `String` describing the regular expression.
     */
    public init(expression: String) {
        self.expression = expression
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input matches the regular expression specified by the receiver.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input matches the regular expression specified by the receiver, otherwise `false`.
     */
    public func evaluate(with input: InputType) -> Bool {
        if let _ = input.range(of: expression, options: .regularExpression) {
            return true
        }
        return false
    }
}
