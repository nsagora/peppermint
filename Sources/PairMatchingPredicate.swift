//
//  PairMatchingPredicate.swift
//  ValidationComponents
//
//  Created by Alex Cristea on 23/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 The `PairMatchingPredicate` struct is used to evaluate whether a given pair of values match.
 */
public struct PairMatchingPredicate<T:Equatable>: Predicate {

    public typealias InputType = (T?, T?)

    /**
     Creates and returns a new `PairMatchingPredicate` instance.
     */
    public init() { }
    
    /**
     Returns a `Boolean` value that indicates whether a given pair of values match.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if the values in the pair match, otherwise `false`.
     */
    public func evaluate(with input: InputType) -> Bool {
        return input.0 == input.1
    }
}
