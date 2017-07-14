import Foundation

public enum FormError: Error {
    case missing
    case invalid(String)
}

extension FormError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
        case .missing:
            return "Input is required"
        case .invalid(let message):
            return "Your input '\(message)' is invalid."
        }
    }
}
