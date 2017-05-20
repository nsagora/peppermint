//
//  Constraint.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 Generic closure for building a localised description of the reason for a failing `Constraint`.
 
 - paramter input: The value of the input, which can be interpolated into the description to provide more insight.
 */
public typealias ErrorBuilder<T> = (T)->Error

/**
 A structrure that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct Constraint<T> {

    private let predicateBuilder: (T)->Bool
    private let errorBuilder: ErrorBuilder<T>

    /**
     Create a new `Constraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P:Predicate>(predicate: P, error: Error) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `Constraint` instance
     
     - parameter predicate: A `Predicate` to describes the evaluation rule.
     - parameter error: A `ErrorBuilder` closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P:Predicate>(predicate: P, error: @escaping ErrorBuilder<T>) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.errorBuilder = error
    }

    /**
     Evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid or a `.invalid` containing the `Error` for the failing `Constraint` otherwise.
     */
    public func evaluate(with input:T) -> EvaluationResult {

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
