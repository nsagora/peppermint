//
//  SimplePredicateViewController.swift
//  Examples
//
//  Created by Alex Cristea on 13/03/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

enum FormError: Error {
    case missing
    case invalid(String)
}

extension FormError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .missing:
            return "<custom feedback message>"
        case .invalid(let message):
            return message
        }
    }
}

class SimplePredicateViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var messageField: UITextField!
    @IBOutlet var label: UILabel!
    
    @IBAction func onEvaluateButtonPress(_ sender:AnyObject) {
        
        guard let text = textField.text else { return assertionFailure() }
        
        let predicate = RegexPredicate(expression: "^\\d+$")
        let error:FormError = messageField.text!.isEmpty ? .missing : .invalid(messageField.text!)
        
        let constraint = Constraint(predicate: predicate, error:error)
        let result = constraint.evaluate(with: text)
        
        switch result {
        case .valid:
            showSuccessAlert(withMessage: "Nice job ;)")
        case .invalid(let error):
            showFailAlert(withMessage: error.localizedDescription)
        }
    }
}
