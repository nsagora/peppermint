//
//  ViewController.swift
//  CocoaPods Examples
//
//  Created by Alex Cristea on 04/03/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

class BlockValidationPredicateViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    
    @IBAction func onEvaluateButtonPress(_ sender:AnyObject) {
        
        guard let text = textField.text else { return assertionFailure() }
        
        let expectedLength = 5
        let predicate = BlockPredicate<String> { $0.characters.count == expectedLength }
        let isValid = predicate.evaluate(with: text)
        
        if isValid {
            showSuccessAlert(withMessage: "Well done ;)")
        }
        else {
           showFailAlert(withMessage: "Expected \(expectedLength) characters.")
        }
    }
}

