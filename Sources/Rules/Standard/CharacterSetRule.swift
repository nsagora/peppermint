import Foundation

/**
 The `CharacterSetRule` evaluates a `String` input agains a defined `CharacterSet`.
 
 ```swift
 let rule = CharacterSetRule(.lowercaseLetters, mode: .inclusive)
 let containsLowercaseLetters = rule.evaluate(with: "Letters")
 ```
 */
public struct CharacterSetRule: Rule {

    /// The `Mode` enum sets the evaluation mode for the input's character set against the provider's character set.
    public enum Mode {
        /**
         The input's character set should be a subset of the provider's character set.
         
         ```swift
         let rule = CharacterSetRule(.lowercaseLetters, mode: .strict)
         let hasOnlyLowercaseLetters = rule.evaluate(with: "letters")
         ```
         */
        case strict
        
        /**
         The input's character set should intersect with the provider's character set.
         
         ```swift
         let rule = CharacterSetRule(.lowercaseLetters, mode: .inclusive)
         let containsLowercaseLetters = rule.evaluate(with: "Letters")
         ```
         */
        case inclusive
    }
    
    public typealias InputType = String
    
    private let characterSet: CharacterSet
    private let mode: Mode
    
    /**
     Returns a new `CharacterSetRule` instance.
     
     ```swift
     let rule = CharacterSetRule(.lowercaseLetters)
     let hasOnlyLowercaseLetters = rule.evaluate(with: "letters")
     ```
     
     - parameter characterSet: A `CharacterSet` used to evaluate a given `String` input.
     - parameter mode: A `Mode` that describes how the input's character set should be evaluated against the provider's character set.
     */
    public init(_ characterSet: CharacterSet, mode: Mode = .strict) {
        self.characterSet = characterSet
        self.mode = mode
    }

    /**
     Returns a `Boolean` value that indicates whether a given `String` contains only characters in the character set.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input  contains only characters in the character set, otherwise `false`.
     */
    public func evaluate(with input: String) -> Bool {
        let inputCharacterSet = CharacterSet(charactersIn: input)
        switch mode {
        case .strict:
            return inputCharacterSet.isSubset(of: characterSet)
        case .inclusive:
            return !inputCharacterSet.intersection(characterSet).isEmpty
        }
        
    }
}

// MARK: - Dynamic Lookup Extension

extension Rule where Self == CharacterSetRule {
    
    /**
     Returns a new `CharacterSetRule` instance.
     
     ```swift
     let rule: CharacterSetRule = .characterSet(.lowercaseLetters)
     let hasOnlyLowercaseLetters = rule.evaluate(with: "letters")
     ```
     
     - parameter characterSet: A `CharacterSet` used to evaluate a given `String` input.
     - parameter mode: A `Mode` that describes how the input's character set should be evaluated against the provider's character set.
     */
    public static func characterSet(_ characterSet: CharacterSet, mode: CharacterSetRule.Mode = .strict) -> Self {
        CharacterSetRule(characterSet, mode: mode)
    }
    
}
