import Foundation

/**
 The `RangeRule` struct is used to evaluate whether a given input is inside a given range.
 
 ```swift
 let drinkingAgeLimit = RangeRule(min: 21)
 let isAllowed = drinkingAgeLimit.evaluate(with: 18)
 ```
 */
public struct RangeRule<T: Comparable>: Rule {
    
    public typealias InputType = T
    
    private let min: T?
    private let max: T?
    
    /**
     Returns a new `RangeRule` instance.
     
     ```swift
     let drinkingAgeLimit = RangeRule(min: 21)
     let isAllowed = drinkingAgeLimit.evaluate(with: 18)
     ```
     
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public init(min: T? = nil, max: T? = nil) {
        self.min = min
        self.max = max
    }
    
    /**
     Returns a new `RangeRule` instance.
     
     ```swift
     let rule = RangeRule(21...90)
     let isAllowed = rule.evaluate(with: 25)
     ```
     
     - parameter range: A `ClosedRange` that defines the lower and upper bounds of the range.
     */
    public init(_ range: ClosedRange<T>) {
        self.init(min: range.lowerBound, max: range.upperBound)
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is inside the given range bounds.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input is between the range bounds, otherwise `false`.
     */
    public func evaluate(with input: T) -> Bool {
        
        if let min = min, let max = max {
            return input >= min && input <= max
        }
        
        if let min = min {
            return input >= min
        }
        
        if let max = max {
            return input <= max
        }
        
        return true
    }
}

extension RangeRule where T: Strideable, T.Stride: SignedInteger {
    
    /**
     Returns a new `RangeRule` instance.
     
     ```swift
     let rule = RangeRule(21..<91)
     let isAllowed = rule.evaluate(with: 25)
     ```
     
     - parameter range: A `Range` that defines the lower and upper bounds of the range.
     */
    public init(_ range: Range<T>) {
        self.init(ClosedRange<T>(range))
    }
}

// MARK: - Dynamic Lookup Extension

extension Rule {
    
    /**
     Returns a new `RangeRule` instance.
     
     ```swift
     let drinkingAgeLimit: RangeRule = .range(min: 21)
     let isAllowed = drinkingAgeLimit.evaluate(with: 18)
     ```
     
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public static func range<T>(min: T? = nil, max: T? = nil) -> Self  where Self == RangeRule<T> {
        RangeRule(min: min, max: max)
    }
    
    /**
     Returns a new `RangeRule` instance.
     
     ```swift
     let rule: RangeRule = .range(21...90)
     let isAllowed = rule.evaluate(with: 25)
     ```
     
     - parameter range: A `ClosedRange` that defines the lower and upper bounds of the range.
     */
    public static func range<T>(_ range: ClosedRange<T>) -> Self where Self == RangeRule<T> {
        self.init(range)
    }
    
    /**
     Returns a new `RangeRule` instance.
     
     ```swift
     let rule: RangeRule = .range(21..<91)
     let isAllowed = rule.evaluate(with: 25)
     ```
     
     - parameter range: A `Range` that defines the lower and upper bounds of the range.
     */
    public static func range<T: Strideable>(_ range: Range<T>) -> Self where Self == RangeRule<T>, T.Stride: SignedInteger {
        self.init(range)
    }
}

