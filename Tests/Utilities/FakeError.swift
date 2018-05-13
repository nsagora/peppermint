import Foundation

enum FakeError: FakeableError {

    case Invalid
    case MissingInput
    case FailingCondition

    case Unexpected(String)
}
