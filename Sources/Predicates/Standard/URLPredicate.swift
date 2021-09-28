import Foundation

/**
 The `URLPredicate` struct is used to evaluate whether a given input is a syntactically valid URL.
 
 ```swift
 let predicate = URLPredicate()
 let isValid = predicate.evaluate(with: "http://www.swift.org")
 ```
 */
public struct URLPredicate: Predicate {
    
    public typealias InputType = String
    
    /**
     Returns a new `URLPredicate` instance.
     
     ```swift
     let predicate = URLPredicate()
     let isValid = predicate.evaluate(with: "http://www.swift.org")
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

extension Predicate where Self == URLPredicate {
    
    /**
     Returns a new `URLPredicate` instance.
     
     ```swift
     let predicate: URLPredicate = .url
     let isValid = predicate.evaluate(with: "http://www.swift.org")
     */
    public static var url: Self {
        URLPredicate()
    }
    
}
