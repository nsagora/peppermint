//
//  ValidationConstraint.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 Generic closure for building a localised description of the reason for a failing `ValidationConstraint`.
 
 - paramter input: The value of the input, which can be interpolated into the description to provide more insight.
 */
public typealias ErrorBuilder<T> = (T)->Error

/**
 A structrure that links a `ValidationPredicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct ValidationConstraint<T> {

    private let predicateBuilder: (T)->Bool
    private let errorBuilder: ErrorBuilder<T>

    /**
     Create a new `ValidationConstraint` instance
     
     - parameter predicate: A `ValidationPredicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P:ValidationPredicate>(predicate: P, error: Error) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `ValidationConstraint` instance
     
     - parameter predicate: A `ValidationPredicate` to describes the evaluation rule.
     - parameter error: A `ErrorBuilder` closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P:ValidationPredicate>(predicate: P, error: @escaping ErrorBuilder<T>) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.errorBuilder = error
    }

    /**
     Evaluates the input on the `ValidationPredicate`.
     
     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid or a `.invalid` containing the `Error` for the failing `ValidationConstraint` otherwise.
     */
    public func evaluate(with input:T) -> ValidationResult {

        let result = predicateBuilder(input)
        
        if result == true {
            return .valid
        }
        else {
            let error = errorBuilder(input)
            return .invalid(error)
        }
    }
}
