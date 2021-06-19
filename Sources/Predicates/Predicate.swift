import Foundation

/**
 The `Predicate` protocol defines the structure that must be implemented by concrete predicates.
 
 ```swift
 public struct CopyCatPredicate: Predicate {

     private let value: String

     public init(value: String) {
         self.value = value
     }

     public func evaluate(with input: String) -> Bool {
         return input == value
     }
 }

 let predicate = CopyCatPredicate(value: "alphabet")
 let isIdentical = predicate.evaluate(with: "alphabet")
 ```
 */
public protocol Predicate: AsyncPredicate {

    /// A type that provides information about what kind of values the predicate can be evaluated with.
    associatedtype InputType
    
    /**
     Returns a `Boolean` value that indicates whether a given input matches the conditions specified by the receiver.
     
     - parameter input: The input against which to evaluate the receiver.
     - returns: `true` if input matches the conditions specified by the receiver, `false` otherwise.
     */
    func evaluate(with input: InputType) -> Bool
}

extension Predicate {
    
    private var workQueue: DispatchQueue {
        return DispatchQueue(label: "com.nsagora.peppermint.predicate", attributes: .concurrent)
    }
    
    /**
     Asynchronous evaluates whether a given input matches the conditions specified by the receiver, then calls a handler upon completion.
     
     - parameter input: The input against which to evaluate the receiver.
     - parameter queue: The queue on which the completion handler is executed. If not specified, it uses `DispatchQueue.main`.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter matches: `true` if input matches the conditions specified by the receiver, `false` otherwise.
     */
    public func evaluate(with input: InputType, queue: DispatchQueue = .main, completionHandler: @escaping (_ matches: Bool) -> Void) {
        
        workQueue.async {
            let result = self.evaluate(with: input)
            
            queue.async {
                completionHandler(result)
            }
        }
    }
}
