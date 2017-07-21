//
//  RegexPredicate.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 05/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 The `RegexPredicate` struct is used to define regluar expression based conditions used to evaluate input strings.
 */
public struct RegexPredicate: Predicate {

    private var expression: String

    /**
     Creates and returns a new `RegexPredicate` instance.
     
     - parameter expression: A `String` describing the regular expression.
     */
    public init(expression: String) {
        self.expression = expression
    }
    
    /**
     Returns a `Boolean` value that indicates whether a given input matches the regular expression specified by the receiver.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input matches the reguar expression specified by the receiver, otherwise `false`.
     */
    public func evaluate(with input: String) -> Bool {

        let predicate = NSPredicate(format: "SELF MATCHES %@", expression)
        return predicate.evaluate(with: input);
    }
}
