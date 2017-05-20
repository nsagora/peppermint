//
//  EvaluationResult.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 The result of a validation action.
 */
public enum EvaluationResult {
    /** 
     Represents a valid validation.
     */
    case valid
    
    /**
     Represents a failed validation. 
     
     It has an associated `Error` to describe the reason of the failure.
     */
    case invalid(Error)
}

extension EvaluationResult {

    /**
     `true` if the validation result is valid, `false` otherwise.
     */
    public var isValid:Bool {
        switch self {
        case .valid:
            return true
        case.invalid:
            return false
        }
    }

    /**
     `false` if the validation result is invalid, `true` otherwise.
     */
    public var isInvalid:Bool {
        return !isValid
    }
    
    /**
     `Error` if the validation result is invalid, `nil` otherwise.
     */
    public var error: Error? {
        switch self {
        case .valid: return nil
        case .invalid(let error): return error
        }
    }
}
