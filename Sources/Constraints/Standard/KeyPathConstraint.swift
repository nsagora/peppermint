import Foundation

/**
 A `Constraint` that evaluates a property on a piece of data by it's key path.
 
 ```swift
 struct LoginData {
     
     enum Error: Swift.Error {
         case email
         case password
     }
     
     var email: String
     var password: String
 }
 ```
 
 ```swift
 let constraint = KeyPathConstraint<LoginData, String, LoginData.Error>(\.email) {
     PredicateConstraint(.email, error: .email)
 }

 let data = LoginData(email: "hello@nsagora.com", password: "p@ssW0rd")
 constraint.evaluate(with: data)
 ```
 */
public struct KeyPathConstraint<T, V, E: Error>: Constraint {
    
    public typealias InputType = T
    public typealias ErrorType = E
    
    private let constraint: AnyConstraint<V, E>
    private let keyPath: KeyPath<T, V>
    
    /**
     Returns a new `KeyPathConstraint` instance.
     
     ```swift
     struct LoginData {
         
         enum Error: Swift.Error {
             case email
             case password
         }
         
         var email: String
         var password: String
     }
     ```
     
     ```swift
     let constraint = KeyPathConstraint<LoginData, String, LoginData.Error>(
         \.email,
         constraint: PredicateConstraint(.email, error: .email)
     )

     let data = LoginData(email: "hello@nsagora.com", password: "p@ssW0rd")
     constraint.evaluate(with: data)
     ```
     
     - parameter keyPath: A
     - parameter constraint: A `Constraint` to describes the evaluation rule for the property at the provided key path.
     */
    public init<C: Constraint>(_ keyPath: KeyPath<T, V>, constraint: C) where C.InputType == V, C.ErrorType == E {
        self.constraint = constraint.erase()
        self.keyPath = keyPath
    }
    
    /**
     Returns a new
     
     ```swift
     struct LoginData {
         
         enum Error: Swift.Error {
             case email
             case password
         }
         
         var email: String
         var password: String
     }
     ```
     
     ```swift
     let constraint = KeyPathConstraint<LoginData, String, LoginData.Error>(\.email) {
         PredicateConstraint(.email, error: .email)
     }

     let data = LoginData(email: "hello@nsagora.com", password: "p@ssW0rd")
     constraint.evaluate(with: data)
     ```
     */
    public init<C: Constraint>(_ keyPath: KeyPath<T, V>, constraintBuilder: () -> C) where C.InputType == V, C.ErrorType == E {
        self.constraint = constraintBuilder().erase()
        self.keyPath = keyPath
    }
    
    /**
     Evaluates the value of the property at the key path against the underlying constraints.

     - parameter input: The input to be validated.
     - returns: `.success` if the value of the input's property is valid,`.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        let value = input[keyPath: keyPath]
        return constraint.evaluate(with: value)
    }
}
