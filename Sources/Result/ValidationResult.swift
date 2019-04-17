import Foundation


/// Validation result type.
///
/// - success: Validation was succesfull
/// - failure: Validation failed. Contains `ValidationResult.Summary` that details the cause for failure
public enum ValidationResult {
    case success
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
