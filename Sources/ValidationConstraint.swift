//
//  ValidationConstraint.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 A structrure that links a `ValidationPredicate` to a localised message that describes why the predicate evaluation has failed.
 */
public struct ValidationConstraint<T> {

    private let predicateBuilder: (T)->Bool
    private let error: Error

    /**
     Create a new `ValidationConstraint` instance
     
     - parameter predicate: A `ValidationPredicate` to describes the evaluation rule.
     - parameter error: An `Error` that describe the reason why the input is invalid.
     */
    public init<P:ValidationPredicate>(predicate: P, error: Error) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.error = error
    }

    /**
     Evaluates the input on the `ValidationPredicate`.
     
     - parameter input: The input to be validated.
     - returns: `.Valid` if the input is valid or a `.Invalid` containng the `ValiationError` of the failing `ValidationConstraint` otherwise.
     */
    public func evaluate(with input:T) -> ValidationResult {

        let result = predicateBuilder(input)
        
        if result == true {
            return .valid
        }
        else {
            return .invalid(error)
        }
    }
}
