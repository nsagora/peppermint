//
//  ValidationPredicate.swift
//  Validator
//
//  Created by Alex Cristea on 05/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import Foundation

public protocol ValidationPredicate {

    associatedtype InputType
    func evaluate(with input: InputType?) -> Bool
}
