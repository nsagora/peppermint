import Foundation

enum FakeError: Error, Equatable {

    case Invalid
    case MissingInput
    case FailingCondition

    case Unexpected(String)
    case Ordered(Int)
}
