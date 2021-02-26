import Foundation

/**
 The `CharacterSetPredicate` struct is used to evaluate a `String` inputs agains a defined `CharacterSet`.
 */
public struct CharacterSetPredicate: Predicate {

    public typealias InputType = String
    
    private let characterSet: CharacterSet
    
    /**
     Creates and returns a new `CharacterSetPredicate` instance.
     
     - parameter characterSet: A `CharacterSet` used to evaluate a given `String` input.
     */
    public init(_ characterSet: CharacterSet) {
        self.characterSet = characterSet
    }

    /**
     Returns a `Boolean` value that indicates whether a given `Srings` contains only characters in the character set.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input  contains only characters in the charecter set, otherwise `false`.
     */
    public func evaluate(with input: String) -> Bool {
        return input.unicodeScalars.allSatisfy { self.characterSet.contains($0)}
    }
}
