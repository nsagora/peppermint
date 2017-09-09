//
//  Error+Equatable.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 03/09/2017.
//  Copyright © 2017 iOS NSAgora. All rights reserved.
//

import Foundation

protocol FakeableError: Error, Equatable { }

extension Error {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.localizedDescription == rhs.localizedDescription)
    }
}
