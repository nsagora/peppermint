//
//  PasswordStrenghtValidationViewController.swift
//  Examples
//
//  Created by Alex Cristea on 13/03/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

enum Form {
    enum Password: Error {
        case missingLowercase
        case missingUpercase
        case missingDigits
        case missingSpecialChars
        case minLenght(Int)
    }
}

extension Form.Password: LocalizedError {
    
    var errorDescription:String? {
        
        switch self {
        case .missingLowercase: return "At least a lower case is required."
        case .missingUpercase: return "At least an upper case is required."
        case .missingDigits: return "At least a digit is required."
        case .missingSpecialChars: return "At least a special character is required."
        case .minLenght(let lenght): return "At least \(lenght) characters are required."
        }
    }
}


class PasswordStrenghtValidationViewController: UITableViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    
    @IBAction func onEvaluateButtonPress(_ sender:AnyObject) {
        
        guard let text = textField.text else { return assertionFailure() }
        
        let validator = buildPasswordStrenghtValidator()
        let results = validator.evaluateAll(input: text)
        
        let errors = results.filter({$0.isInvalid}).flatMap(({$0.error!.localizedDescription}))
        let message = errors.joined(separator: "\n")
        
        if errors.count == 0 {
            showSuccessAlert(withMessage: "Nice done ;)")
        }
        else {
            showFailAlert(withMessage: message)
        }
    }
    
    fileprivate func buildPasswordStrenghtValidator() -> ConstraintSet<String> {
        
        let lowerCasePredicate = RegexPredicate(expression: "^(?=.*[a-z]).*$")
        let upperCasePredicate = RegexPredicate(expression: "^(?=.*[A-Z]).*$")
        let digitsPredicate = RegexPredicate(expression: "^(?=.*[0-9]).*$")
        let specialChars = RegexPredicate(expression: "^(?=.*[!@#\\$%\\^&\\*]).*$")
        let minLenght = RegexPredicate(expression: "^.{8,}$")
        
        var validator = ConstraintSet<String>()
        validator.add(predicate: lowerCasePredicate, error: Form.Password.missingLowercase)
        validator.add(predicate: upperCasePredicate, error: Form.Password.missingUpercase)
        validator.add(predicate: digitsPredicate, error: Form.Password.missingDigits)
        validator.add(predicate: specialChars, error: Form.Password.missingSpecialChars)
        validator.add(predicate: minLenght, error: Form.Password.minLenght(8))
        
        return validator
    }
}
