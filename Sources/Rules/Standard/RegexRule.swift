import Foundation

/**
 The `RegexRule` struct is used to define regular expression based conditions used to evaluate input strings.
 
 ```swift
 let rule = RegexRule(expression: "^\\d+$")
 let isValid = rule.evaluate(with: "1234567890")
 ```
 */
public struct RegexRule: Rule {
    
    public typealias InputType = String
    
    private var expression: String
    
    /**
     Returns a new `RegexRule` instance.
     
     ```swift
     let rule = RegexRule(expression: "^\\d+$")
     let isValid = rule.evaluate(with: "1234567890")
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

// MARK: - Dynamic Lookup Extension

extension Rule where Self == RegexRule {
    
    /**
     Returns a new `RegexRule` instance.
     
     ```swift
     let rule: RegexRule = .regex("^\\d+$")
     let isValid = rule.evaluate(with: "1234567890")
     ```
     
     - parameter expression: A `String` describing the regular expression.
     */
    public static func regex(_ expression: String) -> Self  {
        RegexRule(expression: expression)
    }
}
