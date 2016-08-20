//
//  BlockValidationPredicate.swift
//  ValidationKit
//
//  Created by Alex Cristea on 20/08/16.
//  Copyright © 2016 NSAgora. All rights reserved.
//

import Foundation


struct BlockValidationPredicate<T>: ValidationPredicate {

    private let block: (T?) -> Bool

    init(aBlock:(T?) -> Bool) {
        block = aBlock
    }

    func evaluate(with input: T?) -> Bool {
        return block(input)
    }
}
