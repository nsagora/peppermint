import Foundation

/**
 A value that represents a successfull or a failed evalutation. In case of failure, it contains a `ValidationResult.Summary` that summarises the reason behind it.
 */
public enum ValidationResult {

    /**
     Validation was succesfull.
     */
    case success

    /**
     Validation failed. Contains `ValidationResult.Summary` that details the cause for failure.
     */
    case failure(Summary)
}

public extension ValidationResult {
    
    internal init(summary: Summary) {
        
        if summary.errors.isEmpty {
            self = .success
        }
        else {
            self = .failure(summary)
        }
    }
    
    /**
     `true` if the validation result is valid, `false` otherwise.
     */
    var isSuccessful: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    
    /**
     `false` if the validation result is `.failure` or `.unevaluated`, `true` otherwise.
     */
    var isFailed: Bool {
        return !isSuccessful
    }
    
    /**
     `Summary` of the validation result.
     */
    var summary: Summary {
        switch self {
        case .failure(let summary): return summary
        case .success: return .successful
        }
    }
}


extension ValidationResult: Equatable {}
