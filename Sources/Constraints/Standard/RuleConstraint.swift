import Foundation

/**
 A `Constraint` that links a `Rule` to an `Error` that describes why the rule evaluation has failed.
 
 ```swift
 let constraint = RuleConstraint(.email, error: EmailFailure.invalid)
 let result = constraint.evaluate(with: "hello@nsagora.com)
 ```
 */
public struct RuleConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let rule: any Rule<T>
    private let errorBuilder: (T) -> E

    /**
     Returns a new `RuleConstraint` instance.
     
     ```swift
     let constraint = RuleConstraint(.email, error: EmailFailure.invalid)
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter rule: A `Rule` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init(_ rule: some Rule<T>, error: E) {
        self.rule = rule
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Returns a new `RuleConstraint` instance.
     
     ```swift
     let constraint = RuleConstraint(.email) {
        EmailFailure.invalidFormat($0)
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter rule: A `Rule` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ rule: some Rule<T>, errorBuilder: @escaping (T) -> E) {
        self.rule = rule
        self.errorBuilder = errorBuilder
    }
    
    /**
     Returns a new `RuleConstraint` instance.
     
     ```swift
     let constraint = RuleConstraint(.email) {
        EmailFailure.invalid
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter rule: A `Rule` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ rule: some Rule<T>, errorBuilder: @escaping () -> E) {
        self.rule = rule
        self.errorBuilder = { _ in errorBuilder() }
    }
    
    /**
     Returns a new `RuleConstraint` instance.
     
     ```swift
     let constraint = RuleConstraint {
        .email
     } errorBuilder: {
        EmailFailure.invalidFormat($0)
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter ruleBuilder: A  a closure that dynamically  builds a `Rule` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ ruleBuilder: @escaping () -> some Rule<T>, errorBuilder: @escaping (T) -> E) {
        self.rule = ruleBuilder()
        self.errorBuilder = errorBuilder
    }
    
    /**
     Returns a new `RuleConstraint` instance.
     
     ```swift
     let constraint = RuleConstraint {
        .email
     } errorBuilder: {
        EmailFailure.invalid
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter ruleBuilder: A  a closure that dynamically  builds a `Rule` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init(_ ruleBuilder: @escaping () -> some Rule<T>, errorBuilder: @escaping () -> E) {
        self.rule = ruleBuilder()
        self.errorBuilder = { _ in errorBuilder() }
    }
    
    /**
     Evaluates the input on the provided `Rule`.
     
     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        
        let result = rule.evaluate(with: input)
        
        if result == true {
            return .success
        }
        
        let error = errorBuilder(input)
        return .failure(error)
    }
}
