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

extension Result where Success == Void, Failure == Summary {

    public static func success() -> Result<Success, Failure> { .success(()) }

    internal init(summary: Summary) {
        
        if summary.errors.isEmpty {
            self = .success()
        }
        else {
            self = .failure(summary)
        }
    }
    
    /**
     `Summary` of the validation result.
     */
    public var summary: Summary {
        switch self {
        case .failure(let summary): return summary
        case .success: return .successful
        }
    }
}
