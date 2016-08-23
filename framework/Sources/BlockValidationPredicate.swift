//
//  BlockValidationPredicate.swift
//  ValidationKit
//
//  Created by Alex Cristea on 20/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import Foundation

public typealias ValidationBlock<T> = (T?) -> Bool

public struct BlockValidationPredicate<T>: ValidationPredicate {

    private let block: ValidationBlock<T>

    public init(aBlock:ValidationBlock<T>) {
        block = aBlock
    }

    public func evaluate(with input: T?) -> Bool {
        return block(input)
    }
}
