import Foundation

/**
 A structrure that links an `AsyncPredicate` to an `Error` that describes why the predicate evaluation has failed.
 */
public class ConditionedAsyncConstraint<T>: AsyncConstraint {
    public typealias InputType = T
    
    private var predicate: AnyAsyncPredicate<InputType>
    private var errorBuilder: (InputType) -> Error
    
    var conditions =  [AnyAsyncConstraint<T>]()
    
    /**
     Create a new `ConditionedAsyncConstraint` instance
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An `Error` that describes why the evaluation has failed.
     */
    public init<P: AsyncPredicate>(predicate: P, error: Error) where P.InputType == InputType {
        
        self.predicate = predicate.erase()
        self.errorBuilder = { _ in return error }
    }
    
    /**
     Create a new `ConditionedAsyncConstraint` instance
     
     - parameter predicate: An `AsyncPredicate` to describes the evaluation rule.
     - parameter error: An generic closure that dynamically builds an `Error` to describe why the evaluation has failed.
     */
    public init<P: AsyncPredicate>(predicate: P, error: @escaping (InputType) -> Error) where P.InputType == InputType {
        
        self.predicate = predicate.erase()
        self.errorBuilder = error
    }

    /**
     Add a condition `AsyncConstraint`.

     - parameter constraint: `Constraint`
     */
    public func add<C: AsyncConstraint>(condition: C) where C.InputType == InputType {
        conditions.append(condition.erase())
    }
    
    /**
     Asynchronous evaluates the input on the `Predicate`.
     
     - parameter input: The input to be validated.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter result: `.success` if the input is valid, `.failure` containing the `Summary` of the failing `Constraint`s otherwise.
     */
    public func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result: ValidationResult) -> Void) {
        
        if (!hasConditions()) {
            return continueEvaluate(with: input, queue: queue, completionHandler: completionHandler)
        }
        
        let predicateSet = CompoundAsyncConstraint.and(subconstraints: conditions)
        predicateSet.evaluate(with: input, queue: queue) { result in
            
            if result.isSuccessful {
                return self.continueEvaluate(with: input, queue: queue, completionHandler: completionHandler)
            }
            
            completionHandler(result)
        }
    }
    
    private func hasConditions() -> Bool {
        return conditions.count > 0
    }
    
    private func continueEvaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result: ValidationResult) -> Void) {
        
        predicate.evaluate(with: input, queue: queue) { matches in
            
            if matches {
                completionHandler(.success)
            }
            else {
                let error = self.errorBuilder(input)
                let summary = ValidationResult.Summary(errors: [error])
                completionHandler(.failure(summary))
            }
        }
    }
}
