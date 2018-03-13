//
//  PairMatchingPredicateTests.swift
//  ValidationComponents
//
//  Created by Alex Cristea on 23/08/16.
//  Copyright © 2016 iOS NSAgora. All rights reserved.
//

import XCTest
@testable import ValidationToolkit

class PairMatchingPredicateTests: XCTestCase {

    var predicate: PairMatchingPredicate<String>!

    override func setUp() {
        super.setUp()
        predicate = PairMatchingPredicate()
    }
    
    override func tearDown() {
        predicate = nil
        super.tearDown()
    }

    func testThatItPassesForNilIputs() {
        let result = predicate.evaluate(with: (nil, nil))
        XCTAssertTrue(result)
    }

    func testThatItPassesForMatchingInputs() {
        let result = predicate.evaluate(with: ("nsagora", "nsagora"))
        XCTAssertTrue(result)
    }

    func testThatItFailsForUnmatchingInputs() {
        let result = predicate.evaluate(with: ("swift", "obj-c"))
        XCTAssertFalse(result)
    }
}
