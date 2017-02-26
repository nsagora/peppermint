//
//  Validator.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 15/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 A generic collection of `ValidationConstraints` on which an input can be validated on.
 */
public struct Validator<T> {

    var constraints:[ValidationConstraint<T>]
    
    /**
     Create a new `Validator` instance
     */
    public init() {
        constraints = [ValidationConstraint<T>]()
    }
    
    /**
     Create a new `Validator` instance populated with a predefined list of `ValidationConstraints`
     
     - parameter constraints: `[ValidationConstraint]`
     */
    public init(constraints:[ValidationConstraint<T>]) {
        self.constraints = constraints
    }

    /**
     Create a new `Validator` instance populated with a unsized list of `ValidationConstraints`
     
     - parameter constraints: `[ValidationConstraint]`
     */
    public init(constraints:ValidationConstraint<T>...) {
        self.init(constraints:constraints)
    }
}

extension Validator {

    /**
     Adds a `ValidationConstraint` to the generic collection of constraints.
     
     - parameter constraint: `ValidationConstraint`
     */
    public mutating func add(constraint:ValidationConstraint<T>) {
        constraints.append(constraint)
    }

    /**
     Adds a `ValidationConstraint` to the generic collection of constraints.
     
     - parameter predicate: A `ValidationPredicate` to describes the evaluation rule.
     - parameter message: A localized `String` to describe the reason why the input is invalid.
     */
    public mutating func add<P:ValidationPredicate>(predicate:P, message:String) where P.InputType == T {
        let constraint = ValidationConstraint(predicate: predicate, message: message)
        add(constraint: constraint)
    }

    /**
     Adds a `ValidationConstraint` to the generic collection of constraints.
     
     - parameter predicate: A `ValidationPredicate` to describes the evaluation rule.
     - parameter message: A `MessageBuilder` clouser to dinamicaly build the reason why the input is invalid.
     */
    public mutating func add<P:ValidationPredicate>(predicate:P, message: @escaping MessageBuilder<T>) where P.InputType == T {
        let constraint = ValidationConstraint(predicate: predicate, message: message)
        add(constraint: constraint)
    }
}

extension Validator {

    /**
     Evaluates the input on all `ValidationConstraints` until the first fails.
     
     - parameter input: The input to be validated.
     - returns: `.Valid` if the input is valid or a `.Invalid` containng the `ValiationError` of the failing `ValidationConstraint` otherwise.
     */
    public func evaluateAny(input:T?) -> ValidationResult {
        return constraints.reduce(.valid) { $0.isInvalid ? $0 : $1.evaluate(with: input) }
    }

    /**
     Evaluates the input on all `ValidationConstraints in the collection.
     
     - parameter input: The input to be validated.
     - returns: An array of `ValidationResult` elements, indicating the evaluation result of each `ValidationConstraint` in collection.
     */
    public func evaluateAll(input:T?) -> [ValidationResult] {
        return constraints.map{ $0.evaluate(with:input) }
    }
}
