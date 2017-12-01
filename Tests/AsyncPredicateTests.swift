//
//  AsyncPredicateTests.swift
//  ValidationToolkit
//
//  Created by Alex Cristea on 19/08/2017.
//  Copyright © 2017 iOS NSAgora. All rights reserved.
//

import XCTest
import ValidationToolkit

class AsyncPredicateTests: XCTestCase {
    
    func testThatAnyPredicateIsAlsoAnAsyncPredicate() {
        
        let predicate = MockPredicate<String>()
        let expectetion = expectation(description: "It is called")
        predicate.evaluate(with: "test") { _ in
            expectetion.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}

extension AsyncPredicateTests {
    
    struct MockPredicate<T>: Predicate {
        
        func evaluate(with input: T) -> Bool {
            return true
        }
    }
}
