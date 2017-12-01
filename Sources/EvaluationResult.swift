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
     
     It has an associated `EvaluationResult.Summary` to describe the reason of the failure.
     */
    case invalid(Summary)
}

extension EvaluationResult {

    /**
     `true` if the validation result is valid, `false` otherwise.
     */
    public var isValid:Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }

    /**
     `false` if the validation result is `.invalid` or `.unevaluated`, `true` otherwise.
     */
    public var isInvalid:Bool {
        return !isValid
    }

    /**
     `[Error]` if the validation result is `.invalid`, `nil` otherwise.
     */
    public var errors: [Error]? {
        switch self {
        case .invalid(let summary): return summary.errors
        default: return nil
        }
    }
}

extension EvaluationResult: Equatable {
    
    public static func ==(lhs: EvaluationResult, rhs: EvaluationResult) -> Bool {
        switch (rhs, lhs) {
        case (.valid, .valid): return true
        case (.invalid(let a), .invalid(let b)): return a == b
        default: return false
        }
    }
}

extension EvaluationResult {
    
    public struct Summary: Equatable {
        
        public private(set) var errors = [Error]()
        
        internal init(errors:[Error]) {
            self.errors = errors;
        }
        
        internal init(evaluationResults:[EvaluationResult]) {
            
            var errors = [Error]()
            for result in evaluationResults {
                switch result {
                case .invalid(let summary):
                    errors.append(contentsOf: summary.errors)
                default:
                    continue
                }
            }
            
            self.init(errors: errors)
        }
        
        public static func ==(lhs: Summary, rhs: Summary) -> Bool {
            return lhs.errors.map { $0.localizedDescription } == rhs.errors.map { $0.localizedDescription }
        }
    }
}

extension EvaluationResult {

    internal init(summary:Summary) {

        if summary.errors.count == 0 {
            self = .valid
        }
        else {
            self = .invalid(summary)
        }
    }
}
