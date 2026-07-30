import Foundation

/**
 The `URLRule` struct is used to evaluate whether a given input is a syntactically valid URL.
 
 ```swift
 let rule = URLRule()
 let isValid = rule.evaluate(with: "http://www.swift.org")
 ```
 */
public struct URLRule: Rule {
    
    public typealias InputType = String
    
    /**
     Returns a new `URLRule` instance.
     
     ```swift
     let rule = URLRule()
     let isValid = rule.evaluate(with: "http://www.swift.org")
     */
    public init() { }
    
    /**
     Returns a `Boolean` value that indicates whether a given input is a valid URL.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input is a valid URL, otherwise `false`.
     */
    public func evaluate(with input: InputType) -> Bool {
        return URL(string: input) != nil
    }
}

// MARK: - Dynamic Lookup Extension

extension Rule where Self == URLRule {
    
    /**
     Returns a new `URLRule` instance.
     
     ```swift
     let rule: URLRule = .url
     let isValid = rule.evaluate(with: "http://www.swift.org")
     */
    public static var url: Self {
        URLRule()
    }
    
}
