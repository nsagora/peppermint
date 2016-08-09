//
//  ValidationResult.swift
//  Validator
//
//  Created by Alex Cristea on 09/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import Foundation

public enum ValidationResult {
    case Success
    case Failure(ValidationError)
}

public struct ValidationError: LocalizedError {

    private let message:String

    public init(message:String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
