//
//  ValidationRule.swift
//  Validator
//
//  Created by Alex Cristea on 05/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import Foundation

public protocol ValidationRule {

    associatedtype InputType
    func validate(input: InputType?) -> Bool
}
