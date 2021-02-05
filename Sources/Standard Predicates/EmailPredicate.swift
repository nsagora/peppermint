import Foundation

/**
 The `EmailPredicate` struct is used to evaluate whether a given input is a syntactically valid email address, based on the RFC 5322 official standard.
 */
public struct EmailPredicate: Predicate {
    
    public typealias InputType = String

    private let rule: RegexPredicate
    private let regex = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
        "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
        "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
        "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
        "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
        "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
        "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

    /**
     Creates and returns a new `EmailPredicate` instance.
     */
    public init() {
        rule = RegexPredicate(expression: regex)
    }

    /**
     Returns a `Boolean` value that indicates whether a given email is a syntactically valid, according to the RFC 5322 official standard.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input is a syntactically valid email, according to the RFC 5322 standard, otherwise `false`.
     */
    public func evaluate(with input: InputType) -> Bool {
        return rule.evaluate(with: input)
    }
}
