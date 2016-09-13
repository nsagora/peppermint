//
//  BlockValidationPredicate.swift
//  ValidationKit
//
//  Created by Alex Cristea on 20/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import Foundation

public struct BlockValidationPredicate<T>: ValidationPredicate {

    private let block: (T?) -> Bool

    public init(aBlock:@escaping (T?) -> Bool) {
        block = aBlock
    }

    public func evaluate(with input: T?) -> Bool {
        return block(input)
    }
}
