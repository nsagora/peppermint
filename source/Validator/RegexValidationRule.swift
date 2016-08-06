//
//  RegexValidationRule.swift
//  Validator
//
//  Created by Alex Cristea on 05/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import Foundation

public struct RegexValidationRule: ValidationRule {

    private var expression: String

    public init(expression: String) {
        self.expression = expression
    }

    public func validate(input: String?) -> Bool {

        guard let input = input else { return false }

        let predicate = Predicate(format: "SELF MATCHES[c] %@", expression)
        return predicate.evaluate(with: input);
    }
}
