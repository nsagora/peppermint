import Foundation

extension Result {
    /**
     `true` if the validation result is valid, `false` otherwise.
     */
    public var isSuccessful: Bool {

        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    /**
     `false` if the validation result is `.failure` or `.unevaluated`, `true` otherwise.
     */
    public var isFailure: Bool { !isSuccessful }
}
