import Foundation

public protocol Constraint: AsyncConstraint {

    associatedtype InputType

    func evaluate(with input:InputType) -> Result
}

extension Constraint {

    private var workQueue: DispatchQueue {
        return DispatchQueue(label: "com.nsagora.validation-toolkit.constraint", attributes: .concurrent)
    }

    public func evaluate(with input: InputType, queue: DispatchQueue, completionHandler: @escaping (_ result:Result) -> Void) {

        workQueue.async {
            let result = self.evaluate(with: input)

            queue.async {
                completionHandler(result)
            }
        }
    }
}
