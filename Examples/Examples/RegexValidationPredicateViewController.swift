//
//  RegexValidationPredicateViewController.swift
//  CocoaPods Examples
//
//  Created by Alex Cristea on 04/03/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

class RegexValidationPredicateViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    
    @IBAction func onEvaluateButtonPress(_ sender:AnyObject) {
        
        let predicate = RegexValidationPredicate(expression: "^\\d+$")
        let text = textField.text
        
        let isValid = predicate.evaluate(with: text)
        if isValid {
            showSuccessAlert(withMessage: "Well done ;)")
        }
        else {
            showFailAlert(withMessage: "Expected only digits...")
        }
    }
}
