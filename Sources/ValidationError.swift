//
//  ValidationError.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 12/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

/**
 Contains information about why a validation is invalid.
 */
public struct ValidationError: LocalizedError {

    private let message:String

    internal init(message:String) {
        self.message = message
    }

    /**
     Localised description for the reason of a failing validation.
     */
    public var errorDescription: String? {
        return message
    }
}
