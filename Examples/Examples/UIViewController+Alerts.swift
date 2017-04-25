//
//  UIViewController+Alerts.swift
//  Examples
//
//  Created by Alex Cristea on 22/04/2017.
//  Copyright © 2017 Alex Cristea. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showSuccessAlert(withMessage message:String) {
        showAlert(withTitle: "Successfully evaluated", andMessage: message)
    }
    
    func showFailAlert(withMessage message:String) {
        showAlert(withTitle: "Evaluation failed", andMessage: message)
    }
    
    func showAlert(withTitle title:String, andMessage message: String) {
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
