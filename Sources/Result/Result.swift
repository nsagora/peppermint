import Foundation

/**
 The result of a validation action.
 */
public enum Result {
    /** 
     Represents a valid validation.
     */
    case valid
    
    /**
     Represents a failed validation. 
     
     It has an associated `Result.Summary` to describe the reason of the failure.
     */
    case invalid(Summary)
}

extension Result {

    /**
     `true` if the validation result is valid, `false` otherwise.
     */
    public var isValid:Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }

    /**
     `false` if the validation result is `.invalid` or `.unevaluated`, `true` otherwise.
     */
    public var isInvalid:Bool {
        return !isValid
    }

    /**
     `Summary` of the validation result.
     */
    public var summary: Summary {
        switch self {
        case .invalid(let summary): return summary
        case .valid: return Summary.Successful
        }
    }
}

