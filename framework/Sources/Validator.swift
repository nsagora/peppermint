//
//  Validator.swift
//  ValidationKit
//
//  Created by Alex Cristea on 15/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import Foundation

public struct Validator<T> {

    var constraints = [ValidationConstraint<T>]()
}

extension Validator {

    public mutating func add(constraint:ValidationConstraint<T>) {
        constraints.append(constraint)
    }

    public mutating func add<P:ValidationPredicate>(predicate:P, message:String) where P.InputType == T {
        let constraint = ValidationConstraint(predicate: predicate, message: message)
        add(constraint: constraint)
    }

    public mutating func add<P:ValidationPredicate>(predicate:P, message: MessageBuilder<T>) where P.InputType == T {
        let constraint = ValidationConstraint(predicate: predicate, message: message)
        add(constraint: constraint)
    }
}

extension Validator {

    public func validate(input:T) -> ValidationResult {
        return constraints.reduce(.Success) { $0.isInvalid ? $0 : $1.evaluate(with: input) }
    }

    public func validateAll(input:T) -> [ValidationResult] {
        return constraints.map{ $0.evaluate(with:input) }
    }
}
