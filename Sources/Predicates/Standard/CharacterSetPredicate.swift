import Foundation

/**
 The `CharacterSetPredicate` struct is used to evaluate a `String` inputs agains a defined `CharacterSet`.
 */
public struct CharacterSetPredicate: Predicate {

    /// The `Mode` enum is used to set the evaluation mode of the input's character set against the character set provided at initialisation.
    public enum Mode {
        /// The input's character set should be a subset of the  character set provided at initialisation.
        case strict
        
        /// The input's character set should intersect with the  character set provided at initialisation.
        case loose
    }
    
    public typealias InputType = String
    
    private let characterSet: CharacterSet
    private let mode: Mode
    
    /**
     Creates and returns a new `CharacterSetPredicate` instance.
     
     - parameter characterSet: A `CharacterSet` used to evaluate a given `String` input.
     - parameter mode: A `Mode` that describes how the input's character set should be evaluated against the character set provided at initialisation.
     */
    public init(_ characterSet: CharacterSet, mode: Mode = .strict) {
        self.characterSet = characterSet
        self.mode = mode
    }

    /**
     Returns a `Boolean` value that indicates whether a given `Srings` contains only characters in the character set.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input  contains only characters in the charecter set, otherwise `false`.
     */
    public func evaluate(with input: String) -> Bool {
        let inputCharacterSet = CharacterSet(charactersIn: input)
        switch mode {
        case .strict:
            return inputCharacterSet.isSubset(of: characterSet)
        case .loose:
            return !inputCharacterSet.intersection(characterSet).isEmpty
        }
        
    }
}
