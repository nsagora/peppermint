import Foundation

/**
 The `LengthPredicate` struct is used to evaluate whether a given input is of a given length.
 
 ```swift
 let predicate = LengthPredicate<String>(8...64)
 let isValid = predicate.evaluate(with: "p@ssW0rd")
 ```
 */
public struct LengthPredicate<T: Collection>: Predicate {
    
    public typealias InputType = T
    
    private let predicate: RangePredicate<Int>
    
    /**
     Returns a new `LengthPredicate` instance.
     
     ```swift
     let predicate = LengthPredicate<String>(min: 8, max: 64)
     let isValid = predicate.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public init(min: Int? = nil, max: Int? = nil) {
        self.predicate = RangePredicate(min: min, max: max)
    }
    
    /**
     Creates and returns a new `LengthPredicate` instance.
     
     ```swift
     let predicate = LengthPredicate<String>(8...64)
     let isValid = predicate.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `ClosedRange` that defines the lower and upper bounds of the range.
     */
    public init(_ range: ClosedRange<Int>) {
        self.predicate = RangePredicate(range)
    }
    
    /**
     Creates and returns a new `RangePredicate` instance.
     
     ```swift
     let predicate = LengthPredicate<String>(8..<65)
     let isValid = predicate.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `Range` that defines the lower and upper bounds of the range.
     */
    public init(_ range: Range<Int>) {
        self.predicate = RangePredicate(range)
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is inside the given range bounds.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input is between the range bounds, otherwise `false`.
     */
    public func evaluate(with input: T) -> Bool {
        predicate.evaluate(with: input.count)
    }
}

// MARK: - Dynamic Lookup Extension

extension Predicate {
    
    /**
     Returns a new `LengthPredicate` instance.
     
     ```swift
     let predicate: LengthPredicate<String> = .length(min: 8, max: 64)
     let isValid = predicate.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public static func length<T: Collection>(min: Int? = nil, max: Int? = nil) -> Self where Self == LengthPredicate<T> {
        LengthPredicate(min: min, max: max)
    }
    
    /**
     Creates and returns a new `LengthPredicate` instance.
     
     ```swift
     let predicate: LengthPredicate<String> = .length(8...64)
     let isValid = predicate.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `ClosedRange` that defines the lower and upper bounds of the range.
     */
    public static func length<T: Collection>(_ range: ClosedRange<Int>) -> Self where Self == LengthPredicate<T> {
        LengthPredicate(range)
    }
    
    /**
     Creates and returns a new `RangePredicate` instance.
     
     ```swift
     let predicate: LengthPredicate<String> = .length(8..<65)
     let isValid = predicate.evaluate(with: "p@ssW0rd")
     ```
     
     - parameter range: A `Range` that defines the lower and upper bounds of the range.
     */
    public static func length<T: Collection>(_ range: Range<Int>) -> Self where Self == LengthPredicate<T> {
        LengthPredicate(range)
    }
}
