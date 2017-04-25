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
        
        let expectedLength = 5
        let predicate = BlockValidationPredicate<String> { $0!.characters.count == expectedLength }
        let text = textField.text
        
        let isValid = predicate.evaluate(with: text)
        
        if isValid {
            showSuccessAlert(withMessage: "Well done ;)")
        }
        else {
           showFailAlert(withMessage: "Expected \(expectedLength) characters...")
        }
    }
}

