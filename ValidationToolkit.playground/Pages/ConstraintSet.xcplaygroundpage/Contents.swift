//: [Dynamic Constraint](@previous)

import Foundation
import ValidationToolkit

/*:
 ## ConstraintSet
 
 Use a `ConstraintSet` to evaluate the strength of the user password.
 */

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

let lowerCasePredicate = RegexPredicate(expression: "^(?=.*[a-z]).*$")
let upperCasePredicate = RegexPredicate(expression: "^(?=.*[A-Z]).*$")
let digitsPredicate = RegexPredicate(expression: "^(?=.*[0-9]).*$")
let specialChars = RegexPredicate(expression: "^(?=.*[!@#\\$%\\^&\\*]).*$")
let minLenght = RegexPredicate(expression: "^.{8,}$")

var passwordConstraints = ConstraintSet<String>()
passwordConstraints.add(predicate: lowerCasePredicate, error: Form.Password.missingLowercase)
passwordConstraints.add(predicate: upperCasePredicate, error: Form.Password.missingUpercase)
passwordConstraints.add(predicate: digitsPredicate, error: Form.Password.missingDigits)
passwordConstraints.add(predicate: specialChars, error: Form.Password.missingSpecialChars)
passwordConstraints.add(predicate: minLenght, error: Form.Password.minLenght(8))

let password = "enguard!"
let results:[EvaluationResult] = passwordConstraints.evaluateAll(input: password)
let errors = results.filter({$0.isInvalid}).flatMap({$0.error?.localizedDescription})

if errors.count == 0 {
    print("What a 💪 password we have here!")
}
else {
    print(errors)
}
