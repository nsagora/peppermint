import Foundation

/**
 The `DateRule` struct is used to evaluate that a given input has a valid date format.
 
 ```swift
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "YYYY-MM-dd"
 
 let rule = DateRule(formatter: dateFormatter)
 let isValidDate = rule.evaluate(with: "2021-12-06")
 ```
 */
public struct DateRule: Rule {
    
    public typealias InputType = String
    
    private let dateFormatter: DateFormatter
    
    /**
     Returns a new `DateRule` instance.
     
     ```swift
     let dateFormatter = DateFormatter()
     dateFormatter.dateFormat = "YYYY-MM-dd"
     
     let rule = DateRule(formatter: dateFormatter)
     let isValidDate = rule.evaluate(with: "2021-12-06")
     ```
     
     - parameter formatter: The `DateFormatter` instance used to parse the input.
     */
    public init(formatter: DateFormatter) {
        self.dateFormatter = formatter
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input has a valid date format or not.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input has a valid date format, otherwise `false`.
     */
    public func evaluate(with input: String) -> Bool {
        if let _ = dateFormatter.date(from: input) {
            return true
        }
        return false
    }
    
}
