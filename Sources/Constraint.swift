//
//  Constraint.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 A structrure that links a `Predicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public struct Constraint<T> {

    private let predicateBuilder: (T)->Bool
    private let errorBuilder: (T)->Error

    var conditions =  [Constraint<T>]()

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
     - parameter error: A generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P:Predicate>(predicate: P, error: @escaping (T)->Error) where P.InputType == T {
        self.predicateBuilder = predicate.evaluate
        self.errorBuilder = error
    }

    
    public mutating func add(condition:Constraint<T>) {
        conditions.append(condition)
    }
    
    /**
     Evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - returns: `.valid` if the input is valid or a `.invalid` containing the `Error` for the failing `Constraint` otherwise.
     */
    public func evaluate(with input:T) -> Result {
        
        if !hasConditions() {
            return forwardEvaluation(with: input)
        }
        
        let results = conditions.map { $0.evaluate(with: input) }
        let isPassingConditions = results.filter { $0.isInvalid }.count == 0;
        
        if isPassingConditions {
            return forwardEvaluation(with: input)
        }
        
        let summary = Result.Summary(evaluationResults: results)
        return Result.invalid(summary)
    }
    
    func hasConditions() -> Bool {
        return conditions.count > 0
    }
    
    func forwardEvaluation(with input:T) -> Result {
        
        let result = predicateBuilder(input)
        
        if result == true {
            return .valid
        }
        else {
            let error = errorBuilder(input)
            let summary = Result.Summary(errors: [error])
            return .invalid(summary)
        }
    }
}
