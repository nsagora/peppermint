//
//  ValidationConstraint.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 Generic clouser for building a localised description of the reason for a failing `ValidationConstraint`.
 
 - paramter input: The value of the input, which can be interpolated into the description to provide more insight.
 */
public typealias MessageBuilder<T> = (T?)->String

/**
 A structrure that links a `ValidationPredicate` to a localised message that describes why the predicate evaluation has failed.
 */
public struct ValidationConstraint<T> {

    private let predicateBuilder: (T?) -> Bool
    private let messageBuilder: (T?)->String

    /**
        Create a new `ValidationConstraint` instance
     
     - parameter predicate: A `ValidationPredicate` to describes the evaluation rule.
     - parameter message: A localized `String` to describe the reason why the input is invalid.
     */
    public init<P:ValidationPredicate>(predicate: P, message: String) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.messageBuilder = { _ in return message }
    }

    /**
     Create a new `ValidationConstraint` instance
     
     - parameter predicate: A `ValidationPredicate` to describes the evaluation rule.
     - parameter message: A `MessageBuilder` clouser to dinamicaly build the reason why the input is invalid.
     */
    public init<P:ValidationPredicate>(predicate: P, message: @escaping MessageBuilder<T>) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.messageBuilder = message
    }

    /**
     Evaluates the input on the `ValidationPredicate`.
     
     - parameter input: The input to be validated.
     - returns: `.Valid` if the input is valid or a `.Invalid` containng the `ValiationError` of the failing `ValidationConstraint` otherwise.
     */
    public func evaluate(with input:T?) -> ValidationResult {

        let result = predicateBuilder(input)
        
        if result == true {
            return .valid
        }
        else {
            let message = messageBuilder(input)
            let error = ValidationError(message: message)
            return .invalid(error)
        }
    }
}
