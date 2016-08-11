//
//  ValidationConstraint.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

public struct ValidationConstraint<T> {

    private let predicate: (T?) -> Bool
    private let message: String

    public init<P:ValidationPredicate where P.InputType == T >(predicate: P, message: String) {
        self.predicate = predicate.evaluate
        self.message = message
    }

    public func evaluate(with input:T?) -> ValidationResult {

        let result = predicate(input)

        if result == true {
            return .Success
        }
        else {
            let error = ValidationError(message: message)
            return .Failure(error)
        }
    }
}
