//
//  DynamicErrorConstraintViewController.swift
//  Examples
//
//  Created by Alex Cristea on 23/05/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

// MARK: - FormError

fileprivate enum FormError: Error {
    case invalid(String)
}

extension FormError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .invalid(let message):
            return "The input «\(message)» is invalid."
        }
    }
}

// MARK: - ViewController

class DynamicErrorConstraintViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    
    @IBAction func onEvaluateButtonPress(_ sender:AnyObject) {
        
        guard let text = textField.text else { return assertionFailure() }
        
        let predicate = RegexPredicate(expression: "^\\d+$")
    
        let constraint = Constraint(predicate: predicate) { return FormError.invalid($0)}
        let result = constraint.evaluate(with: text)
        
        switch result {
        case .valid:
            showSuccessAlert(withMessage: "Nice job ;)")
        case .invalid(let error):
            showFailAlert(withMessage: error.localizedDescription)
        }
    }
}
