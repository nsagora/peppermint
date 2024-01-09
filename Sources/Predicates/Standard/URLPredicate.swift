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
        return  parseURL(from: input) != nil
    }
    
    private func parseURL(from input: String) -> URL? {
        if #available(macOS 14.0, macCatalyst 17.0, iOS 17.0, watchOS 10.0, tvOS 10.0, visionOS 1.0, *) {
            return URL(string: input, encodingInvalidCharacters: false)
        } else {
            return URL(string: input)
        }
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
