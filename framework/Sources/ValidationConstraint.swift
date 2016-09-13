//
//  ValidationConstraint.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

public typealias MessageBuilder<T> = (T?)->String

public struct ValidationConstraint<T> {

    private let predicateClosure: (T?) -> Bool
    private let messageClosure: (T?)->String

    public init<P:ValidationPredicate>(predicate: P, message: String) where P.InputType == T {
        self.predicateClosure = predicate.evaluate
        self.messageClosure = { _ in return message }
    }

    public init<P:ValidationPredicate>(predicate: P, message: @escaping MessageBuilder<T>) where P.InputType == T {
        self.predicateClosure = predicate.evaluate
        self.messageClosure = message
    }

    public func evaluate(with input:T?) -> ValidationResult {

        let result = predicateClosure(input)
        let message = messageClosure(input)

        if result == true {
            return .Valid
        }
        else {
            let error = ValidationError(message: message)
            return .Invalid(error)
        }
    }
}
