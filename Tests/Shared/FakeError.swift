import Foundation

enum FakeError: Error {

    case Invalid
    case MissingInput
    case FailingCondition

    case Unexpected(String)
    case Ordered(Int)
}
