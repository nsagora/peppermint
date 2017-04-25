//
//  PasswordStrenghtValidationViewController.swift
//  Examples
//
//  Created by Alex Cristea on 13/03/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

class PasswordStrenghtValidationViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var label: UILabel!
    
    @IBAction func onEvaluateButtonPress(_ sender:AnyObject) {

        let text = textField.text
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
    
    fileprivate func buildPasswordStrenghtValidator() -> Validator<String> {
        
        let lowerCasePredicate = RegexValidationPredicate(expression: "^(?=.*[a-z]).*$")
        let upperCasePredicate = RegexValidationPredicate(expression: "^(?=.*[A-Z]).*$")
        let digitsPredicate = RegexValidationPredicate(expression: "^(?=.*[0-9]).*$")
        let specialChars = RegexValidationPredicate(expression: "^(?=.*[!@#\\$%\\^&\\*]).*$")
        let minLenght = RegexValidationPredicate(expression: "^.{8,}$")
        
        var validator = Validator<String>()
        validator.add(predicate: lowerCasePredicate, message: "At least a lower case is required")
        validator.add(predicate: upperCasePredicate, message: "At least an upper case is required")
        validator.add(predicate: digitsPredicate, message: "At least a digit is required")
        validator.add(predicate: specialChars, message: "At least a special character is required")
        validator.add(predicate: minLenght, message: "At least 8 characters are required")
        
        return validator
    }
    
    @IBAction func onResetButtonPress(_ sender:AnyObject) {
        textField.text = nil
        label.text = nil
    }
    
    @IBAction func onTextFieldChange(_ sender:AnyObject) {
        label.text = nil
        label.textColor = .black
    }

}
