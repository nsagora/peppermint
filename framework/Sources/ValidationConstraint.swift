//
//  ValidationConstraint.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

public struct ValidationConstraint<T> {

    private let predicateClosure: (T?) -> Bool
    private let messageClosure: (T?) -> String

    public init<P:ValidationPredicate where P.InputType == T>(predicate: P, message: String) {
        self.predicateClosure = predicate.evaluate
        self.messageClosure = { _ in return message }
    }

    public init<P:ValidationPredicate where P.InputType == T>(predicate: P, message: (T?)->String) {
        self.predicateClosure = predicate.evaluate
        self.messageClosure = message
    }

    public func evaluate(with input:T?) -> ValidationResult {

        let result = predicateClosure(input)
        let message = messageClosure(input)

        if result == true {
            return .Success
        }
        else {
            let error = ValidationError(message: message)
            return .Failure(error)
        }
    }
}
