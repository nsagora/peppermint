//
//  ValidationError.swift
//  ValidationKit
//
//  Created by Alex Cristea on 12/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

public struct ValidationError: LocalizedError {

    private let message:String

    public init(message:String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
