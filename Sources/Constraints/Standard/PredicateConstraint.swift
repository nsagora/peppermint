import Foundation

/**
 A `Constraint` that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 
 ```swift
 let constraint = PredicateConstraint(EmailPredicate(), error: EmailFailure.invalid)
 let result = constraint.evaluate(with: "hello@nsagora.com)
 ```
 */
public struct PredicateConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let predicate: AnyPredicate<T>
    private let errorBuilder: (T) -> E

    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint = PredicateConstraint(EmailPredicate(), error: EmailFailure.invalid)
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P: Predicate>(_ predicate: P, error: E) where P.InputType == InputType {
        self.predicate = predicate.erase()
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint = PredicateConstraint(EmailPredicate()) {
        EmailFailure.invalidFormat($0)
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P: Predicate>(_ predicate: P, errorBuilder: @escaping (T) -> E) where P.InputType == T {
        self.predicate = predicate.erase()
        self.errorBuilder = errorBuilder
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint = PredicateConstraint(EmailPredicate()) {
        EmailFailure.invalid
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P: Predicate>(_ predicate: P, errorBuilder: @escaping () -> E) where P.InputType == T {
        self.predicate = predicate.erase()
        self.errorBuilder = { _ in errorBuilder() }
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint = PredicateConstraint {
        EmailPredicate()
     } errorBuilder: {
        EmailFailure.invalidFormat($0)
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicateBuilder: A  a closure that dynamically  builds a `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P: Predicate>(_ predicateBuilder: @escaping () -> P, errorBuilder: @escaping (T) -> E) where P.InputType == T {
        self.predicate = predicateBuilder().erase()
        self.errorBuilder = errorBuilder
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint = PredicateConstraint {
        EmailPredicate()
     } errorBuilder: {
        EmailFailure.invalid
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicateBuilder: A  a closure that dynamically  builds a `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P: Predicate>(_ predicateBuilder: @escaping () -> P, errorBuilder: @escaping () -> E) where P.InputType == T {
        self.predicate = predicateBuilder().erase()
        self.errorBuilder = { _ in errorBuilder() }
    }
    
    /**
     Evaluates the input on the provided `Predicate`.
     
     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        
        let result = predicate.evaluate(with: input)
        
        if result == true {
            return .success(())
        }
        
        let error = errorBuilder(input)
        let summary = Summary(errors: [error])
        return .failure(summary)
    }
}

// MARK: - Dynamic Lookup Extension

extension Constraint {
 
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint: PredicateConstraint<String, EmailFailure> = .predicate(.email, error: .invalid)
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public static func predicate<T, E, P: Predicate>(_ predicate: P, error: E) -> Self where Self == PredicateConstraint<T, E>, P.InputType == T {
        PredicateConstraint(predicate, error: error)
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint: PredicateConstraint<String, EmailFailure> = .predicate(.email) {
        .invalidFormat($0)
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public static func predicate<T, E, P: Predicate>(_ predicate: P, errorBuilder: @escaping (T) -> E) -> Self where Self == PredicateConstraint<T, E>, P.InputType == T {
        PredicateConstraint(predicate, errorBuilder: errorBuilder)
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint: PredicateConstraint<String, EmailFailure>(.email) {
        .invalid
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public static func predicate<T, E, P: Predicate>(_ predicate: P, errorBuilder: @escaping () -> E) -> Self where Self == PredicateConstraint<T, E>, P.InputType == T {
        PredicateConstraint(predicate, errorBuilder: errorBuilder)
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint: PredicateConstraint<String, EmailFailure> = .predicate {
        .email
     } errorBuilder: {
        .invalidFormat($0)
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicateBuilder: A  a closure that dynamically  builds a `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public static func predicate<T, E, P: Predicate>(_ predicateBuilder: @escaping () -> P, errorBuilder: @escaping (T) -> E) -> Self where Self == PredicateConstraint<T, E>, P.InputType == T {
        PredicateConstraint(predicateBuilder, errorBuilder: errorBuilder)
    }
    
    /**
     Returns a new `PredicateConstraint` instance.
     
     ```swift
     let constraint: PredicateConstraint<String, EmailFailure> = .predicate {
        .email
     } errorBuilder: {
        .invalid
     }
     let result = constraint.evaluate(with: "hello@nsagora.com)
     ```
     
     - parameter predicateBuilder: A  a closure that dynamically  builds a `Predicate` to describes the evaluation rule.
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public static func predicate<T, E, P: Predicate>(_ predicateBuilder: @escaping () -> P, errorBuilder: @escaping () -> E) -> Self where Self == PredicateConstraint<T, E>, P.InputType == T {
        PredicateConstraint(predicateBuilder, errorBuilder: errorBuilder)
    }
}
