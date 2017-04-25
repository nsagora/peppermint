//
//  SimplePredicateViewController.swift
//  Examples
//
//  Created by Alex Cristea on 13/03/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

class SimplePredicateViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var messageField: UITextField!
    @IBOutlet var label: UILabel!
    
    @IBAction func onEvaluateButtonPress(_ sender:AnyObject) {
        
        let predicate = RegexValidationPredicate(expression: "^\\d+$")
        let text = textField.text
        let message = messageField.text!.isEmpty ? "<custom feedback message>" : messageField.text!
        
        let constraint = ValidationConstraint(predicate: predicate, message: message)
        let result = constraint.evaluate(with: text)
        
        switch result {
        case .valid:
            showSuccessAlert(withMessage: "Nice job ;)")
        case .invalid(let error):
            showFailAlert(withMessage: error.errorDescription!)
        }
    }
}
