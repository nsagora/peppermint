import Foundation

public protocol AsyncConstraint {

    associatedtype InputType

    func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void)
}
