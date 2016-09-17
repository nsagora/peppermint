//
//  ValidationResult.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 The result of a validation action.
 */
public enum ValidationResult {
    /** 
     Represents a valid validation.
     */
    case Valid
    
    /**
     Represents a failed validation. 
     
     It has an associated `ValidationError` to describe the reason of the failure.
     */
    case Invalid(ValidationError)
}

extension ValidationResult {

    /**
     `true` if the validation result is valid, `false` otherwise.
     */
    public var isValid:Bool {
        switch self {
        case .Valid:
            return true
        case.Invalid:
            return false
        }
    }

    /**
     `false` if the validation result is invalid, `true` otherwise.
     */
    public var isInvalid:Bool {
        return !isValid
    }
}
