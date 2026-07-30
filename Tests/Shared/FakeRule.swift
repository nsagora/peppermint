import Peppermint

struct FakeRule<T>: Rule where T: Equatable {

    typealias InputType = T

    var expected: T

    func evaluate(with input: T) -> Bool {
        return input == expected
    }
}
