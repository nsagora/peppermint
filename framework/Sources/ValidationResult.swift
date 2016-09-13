//
//  ValidationResult.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

public enum ValidationResult {
    case Valid
    case Invalid(ValidationError)
}

extension ValidationResult {

    public var isValid:Bool {
        switch self {
        case .Valid:
            return true
        case.Invalid:
            return false
        }
    }

    public var isInvalid:Bool {
        return !isValid
    }
}
