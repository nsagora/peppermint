import Foundation

/**
 A `Constraint` that allows to evaluate complex data types.
 
 ```swift
 struct RegistrationData {
     
     enum Error: Swift.Error {
         case username
         case password(Password)
         case email
         case underAge
     }
     
     enum Password {
         case missingUppercase
         case missingLowercase
         case missingDigits
         case missingSpecialChars
         case tooShort
     }
     
     var username: String
     var password: String
     var email: String
     var age: Int
 }
 ```
 
 ```swift
 var constraint = TypeConstraint<RegistrationData, RegistrationData.Error> {
     KeyPathConstraint(\.username) {
         BlockConstraint {
             $0.count >= 5
         } errorBuilder: {
             .username
         }
     }
     KeyPathConstraint(\.password) {
         GroupConstraint(.all) {
             PredicateConstraint {
                 CharacterSetPredicate(.lowercaseLetters, mode: .inclusive)
             } errorBuilder: {
                 .password(.missingLowercase)
             }
             PredicateConstraint{
                 CharacterSetPredicate(.uppercaseLetters, mode: .inclusive)
             } errorBuilder: {
                 .password(.missingUppercase)
             }
             PredicateConstraint {
                 CharacterSetPredicate(.decimalDigits, mode: .inclusive)
             } errorBuilder: {
                 .password(.missingDigits)
             }
             PredicateConstraint {
                 CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
             } errorBuilder: {
                 .password(.missingSpecialChars)
             }
             PredicateConstraint {
                 LengthPredicate(min: 8)
             }  errorBuilder: {
                 .password(.tooShort)
             }
         }
     }
     KeyPathConstraint(\.email) {
         PredicateConstraint(EmailPredicate(), error: .email)
     }
     KeyPathConstraint(\.age) {
         PredicateConstraint(RangePredicate(min: 14), error: .underAge)
     }
 }

 let user = RegistrationData(username: "nsagora", password: "p@ssW0rd", email: "hello@nsagora.com", age: 21)
 constraint.evaluate(with: user)
 */
public struct TypeConstraint<T, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E

    private var constraints = [AnyConstraint<T, E>]()

    /**
     Create a new `TypeConstraint` instance.
     
     ```swift
     struct RegistrationData {
         
         enum Error: Swift.Error {
             case username
             case password(Password)
             case email
             case underAge
         }
         
         enum Password {
             case missingUppercase
             case missingLowercase
             case missingDigits
             case missingSpecialChars
             case tooShort
         }
         
         var username: String
         var password: String
         var email: String
         var age: Int
     }
     ```
     
     ```swift

     var constraint = TypeConstraint<RegistrationData, RegistrationData.Error>()

     constraint.set(for: \.username) {
         BlockConstraint {
             $0.count >= 5
         } errorBuilder: {
             .username
         }
     }

     constraint.set(for: \.password) {
         GroupConstraint(.all, constraints:
             PredicateConstraint {
                 CharacterSetPredicate(.lowercaseLetters, mode: .inclusive)
             } errorBuilder: {
                 .password(.missingLowercase)
             },
             PredicateConstraint{
                 CharacterSetPredicate(.uppercaseLetters, mode: .inclusive)
             } errorBuilder: {
                 .password(.missingUppercase)
             },
             PredicateConstraint {
                 CharacterSetPredicate(.decimalDigits, mode: .inclusive)
             } errorBuilder: {
                 .password(.missingDigits)
             },
             PredicateConstraint {
                 CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
             } errorBuilder: {
                 .password(.missingSpecialChars)
             },
             PredicateConstraint {
                 LengthPredicate(min: 8)
             }  errorBuilder: {
                 .password(.tooShort)
             }
         )
     }

     constraint.set(for: \.email) {
         PredicateConstraint(EmailPredicate(), error: .email)
     }

     constraint.set(for: \.age) {
         PredicateConstraint(RangePredicate(min: 14), error: .underAge)
     }

     let user = RegistrationData(username: "nsagora", password: "p@ssW0rd", email: "hello@nsagora.com", age: 21)
     constraint.evaluate(with: user)
    ```
     */
    public init() {}

    /**
     Set a `Constraint` on a property from the root object.

     - parameter constraint: A `Constraint` on the property at the provided `KeyPath`.
     - parameter keyPath: The `KeyPath` for the property we set the `Constraint` on.
     */
    public mutating func set<C: Constraint, V>(for keyPath: KeyPath<T, V>, constraint: C) where C.InputType == V, C.ErrorType == E {
        let constraint = KeyPathConstraint(keyPath, constraints: constraint).erase()
        constraints.append(constraint)
    }
    
    /**
     Set a `Constraint` on a property from the root object.

     - parameter constraint: A `Constraint` on the property at the provided `KeyPath`.
     - parameter keyPath: The `KeyPath` for the property we set the `Constraint` on.
     */
    public mutating func set<C: Constraint, V>(for keyPath: KeyPath<T, V>, constraintBuilder: () -> C ) where C.InputType == V, C.ErrorType == E {
        let constraint = KeyPathConstraint(keyPath, constraints: constraintBuilder()).erase()
        constraints.append(constraint)
    }

    /**
     Evaluates the input against the underlying constraints.

     - parameter input: The input to be validated.
     - returns: `.success` if the input is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        return GroupConstraint(constraints: constraints).evaluate(with: input)
    }
}

// MARK: - ConstraintBuilder Extension

extension TypeConstraint {
    
    /**
     Create a new `TypeConstraint` instance.
     
     ```swift
     struct RegistrationData {
         
         enum Error: Swift.Error {
             case username
             case password(Password)
             case email
             case underAge
         }
         
         enum Password {
             case missingUppercase
             case missingLowercase
             case missingDigits
             case missingSpecialChars
             case tooShort
         }
         
         var username: String
         var password: String
         var email: String
         var age: Int
     }
     ```
     
     ```swift
     var constraint = TypeConstraint<RegistrationData, RegistrationData.Error> {
         KeyPathConstraint(\.username) {
             BlockConstraint {
                 $0.count >= 5
             } errorBuilder: {
                 .username
             }
         }
         KeyPathConstraint(\.password) {
             GroupConstraint(.all) {
                 PredicateConstraint {
                     CharacterSetPredicate(.lowercaseLetters, mode: .inclusive)
                 } errorBuilder: {
                     .password(.missingLowercase)
                 }
                 PredicateConstraint{
                     CharacterSetPredicate(.uppercaseLetters, mode: .inclusive)
                 } errorBuilder: {
                     .password(.missingUppercase)
                 }
                 PredicateConstraint {
                     CharacterSetPredicate(.decimalDigits, mode: .inclusive)
                 } errorBuilder: {
                     .password(.missingDigits)
                 }
                 PredicateConstraint {
                     CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .inclusive)
                 } errorBuilder: {
                     .password(.missingSpecialChars)
                 }
                 PredicateConstraint {
                     LengthPredicate(min: 8)
                 }  errorBuilder: {
                     .password(.tooShort)
                 }
             }
         }
         KeyPathConstraint(\.email) {
             PredicateConstraint(EmailPredicate(), error: .email)
         }
         KeyPathConstraint(\.age) {
             PredicateConstraint(RangePredicate(min: 14), error: .underAge)
         }
     }

     let user = RegistrationData(username: "nsagora", password: "p@ssW0rd", email: "hello@nsagora.com", age: 21)
     constraint.evaluate(with: user)
     */
    public init(@ConstraintBuilder<T, E> constraintBuilder: () -> [AnyConstraint<T, E>])  {
        self.constraints = constraintBuilder()
    }
}
