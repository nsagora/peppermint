//
// Result+Summary.swift
// ValidationToolkit iOS
//
// Created by Dmitry Mazurenko on 4/17/19.
// Copyright © 2019 iOS NSAgora. All rights reserved.
// 
// 

import Foundation


public extension ValidationResult {
    /**
     The summary of a validation result.
     */
    struct Summary {
        
        /**
         `[Error]` if the validation result is `.failure`, `nil` otherwise.
         */
        public private(set) var errors = [Error]()
        
        /**
         The number of failing constraints for a `.failure` result, `0` otherwise.
         */
        public var failingConstraints: Int {
            return errors.count
        }
        
        /**
         `true` if the validation result is `.failure`, `false` otherwise.
         */
        public var hasFailingContraints: Bool {
            return failingConstraints > 0
        }
        
        internal init(errors: [Error]) {
            self.errors = errors
        }
        
        internal init(evaluationResults: [ValidationResult]) {
            self.init(
                errors: evaluationResults
                    .filter { $0.isFailed }
                    .reduce(into: [Error]()) { (errors, result) in
                        errors += result.summary.errors
                }
            )
        }
    }
}


// MARK: - Equatable conformance

extension ValidationResult.Summary: Equatable {
    
    public static func ==(lhs: ValidationResult.Summary, rhs: ValidationResult.Summary) -> Bool {
        return lhs.errors.map { $0.localizedDescription } == rhs.errors.map { $0.localizedDescription }
    }
}

// MARK: - Factory methods

extension ValidationResult.Summary {
    internal static var successful = ValidationResult.Summary(errors: [])
}
