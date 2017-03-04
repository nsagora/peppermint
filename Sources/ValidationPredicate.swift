//
//  ValidationPredicate.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 05/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 The `ValidationPredicate` predicate is used to define the structre that must be implemented by concrete predicates.
 */
public protocol ValidationPredicate {

    /**
     A type that provides information about what kind of values the predicate can be evaluated with.
     */
    associatedtype InputType
    
    /**
     Returns a `Boolean` value that indicates whether a given input matches the conditions specified by the receiver.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input matches the conditions specified by the receiver, otherwise `false`.
     */
    func evaluate(with input: InputType?) -> Bool
}
