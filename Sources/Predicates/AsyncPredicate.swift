import Foundation

/**
 The `AsyncPredicate` protocol is used to define the structre that must be implemented by concrete async predicates.
 */
public protocol AsyncPredicate {
    
    /**
     A type that provides information about what kind of values the predicate can be evaluated with.
     */
    associatedtype InputType
    
    /**
     Asynchronous evaluates whether a given input matches the conditions specified by the receiver, then calls a handler upon completion.
     
     - parameter input: The input against which to evaluate the receiver.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter matches: `true` if input matches the conditions specified by the receiver, `false` otherwise.
     */
    func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ matches:Bool) -> Void)
}
