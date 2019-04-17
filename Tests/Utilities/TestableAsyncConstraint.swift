import Foundation
import ValidationToolkit

class TestableAsyncConstraint<T>: AsyncConstraint {

    var block: (()->())?

    func evaluate(with input: T, queue: DispatchQueue, completionHandler: @escaping (ValidationResult) -> Void) {
        block?()
    }
}
