import Foundation

/**
 A type-erased `AsyncPredicate`.
 */
public class AnyAsyncPredicate<T>: AsyncPredicate {

    /**
     A type that provides information about what kind of values the predicate can be evaluated with.
     */
    public typealias InputType = T

    var _evaluate: (InputType, DispatchQueue, @escaping (Bool) -> Void) -> Void

    /**
     Creates a type-erased `AsyncPredicate` that wraps the given instance.
     */
    public init<P: AsyncPredicate>(_ predicate: P) where P.InputType == InputType {
        _evaluate = predicate.evaluate
    }

    /**
     Asynchronous evaluates whether a given input matches the conditions specified by the receiver, then calls a handler upon completion.

     - parameter input: The input against which to evaluate the receiver.
     - parameter queue: The queue on which the completion handler is executed.
     - parameter completionHandler: The completion handler to call when the evaluation is complete. It takes a `Bool` parameter:
     - parameter matches: `true` if input matches the conditions specified by the receiver, `false` otherwise.
     */
    public func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ matches:Bool) -> Void) {
        _evaluate(input, queue, completionHandler)
    }
}

extension AsyncPredicate {

    /**
     Creates a type-erased `AsyncPredicate` that wraps the given instance.
     */
    internal func erase() -> AnyAsyncPredicate<InputType> {
        return AnyAsyncPredicate(self)
    }
}
