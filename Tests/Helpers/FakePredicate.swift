import Foundation
import ValidationToolkit

struct FakePredicate<T>: Predicate  where T:Equatable {

    var expected: T

    func evaluate(with input: T) -> Bool {
        return input == expected
    }
}
