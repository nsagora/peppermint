import Foundation

/**
 The `LengthPredicate` struct is used to evaluate whether a given input is of a given length.
 */
public struct LengthPredicate<T: Collection>: Predicate {
    
    public typealias InputType = T
    
    private let predicate: RangePredicate<Int>
    
    /**
     Creates and returns a new `LengthPredicate` instance.
     :
     - parameter min: The lower bound of the range.
     - parameter max: The upper bound of the range.
     */
    public init(min: Int? = nil, max: Int? = nil) {
        self.predicate = RangePredicate(min: min, max: max)
    }
    
    /**
     Creates and returns a new `LengthPredicate` instance.
     :
     - parameter range: A `ClosedRange` that defines the lower and uppper bounds of the range.
     */
    public init(_ range: ClosedRange<Int>) {
        self.predicate = RangePredicate(range)
    }
    
    /**
     Creates and returns a new `RangePredicate` instance.
     :
     - parameter range: A `Range` that defines the lower and uppper bounds of the range.
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
        
        return predicate.evaluate(with: input.count)
    }
}
