import Foundation

/**
 The `LengthRule` struct is used to evaluate whether a given input is of a given length.
 
 ```swift
 let rule = LengthRule<String>(8...64)
 let isValid = rule.evaluate(with: "p@ssW0rd")
 ```
 */
public struct LengthRule<T: Collection>: Rule {
    
    public typealias InputType = T
    
    private let rule: RangeRule<Int>
    
    /**
     Returns a new `LengthRule` instance.
     
     ```swift
     let rule = LengthRule<String>(min: 8, max: 64)
     let isValid = rule.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public init(min: Int? = nil, max: Int? = nil) {
        self.rule = RangeRule(min: min, max: max)
    }
    
    /**
     Creates and returns a new `LengthRule` instance.
     
     ```swift
     let rule = LengthRule<String>(8...64)
     let isValid = rule.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `ClosedRange` that defines the lower and upper bounds of the range.
     */
    public init(_ range: ClosedRange<Int>) {
        self.rule = RangeRule(range)
    }
    
    /**
     Creates and returns a new `RangeRule` instance.
     
     ```swift
     let rule = LengthRule<String>(8..<65)
     let isValid = rule.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `Range` that defines the lower and upper bounds of the range.
     */
    public init(_ range: Range<Int>) {
        self.rule = RangeRule(range)
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is inside the given range bounds.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input is between the range bounds, otherwise `false`.
     */
    public func evaluate(with input: T) -> Bool {
        rule.evaluate(with: input.count)
    }
}

// MARK: - Dynamic Lookup Extension

extension Rule {
    
    /**
     Returns a new `LengthRule` instance.
     
     ```swift
     let rule: LengthRule<String> = .length(min: 8, max: 64)
     let isValid = rule.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public static func length<T: Collection>(min: Int? = nil, max: Int? = nil) -> Self where Self == LengthRule<T> {
        LengthRule(min: min, max: max)
    }
    
    /**
     Creates and returns a new `LengthRule` instance.
     
     ```swift
     let rule: LengthRule<String> = .length(8...64)
     let isValid = rule.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `ClosedRange` that defines the lower and upper bounds of the range.
     */
    public static func length<T: Collection>(_ range: ClosedRange<Int>) -> Self where Self == LengthRule<T> {
        LengthRule(range)
    }
    
    /**
     Creates and returns a new `RangeRule` instance.
     
     ```swift
     let rule: LengthRule<String> = .length(8..<65)
     let isValid = rule.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `Range` that defines the lower and upper bounds of the range.
     */
    public static func length<T: Collection>(_ range: Range<Int>) -> Self where Self == LengthRule<T> {
        LengthRule(range)
    }
}
