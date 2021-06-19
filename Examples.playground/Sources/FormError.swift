import Foundation

// MARK: - Definition

public enum Form {
    
    public enum Username: Error {
        case missing
        case invalid(String)
    }
    
    public enum Password: Error {
        case missingLowercase
        case missingUppercase
        case missingDigits
        case missingSpecialChars
        case minLength(Int)
    }
    
    public enum Email: Error {
        case missing
        case invalid(String)
    }
    
    public enum Age: Error {
        case underage
    }
}

// MARK: - Localisation

extension Form.Username: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
        case .missing: return "Username is required"
        case .invalid(let message): return "Your username '\(message)' is invalid."
        }
    }
}

extension Form.Password: LocalizedError {
    public var errorDescription:String? {
        
        switch self {
        case .missingLowercase: return "At least a lower case is required."
        case .missingUppercase: return "At least an upper case is required."
        case .missingDigits: return "At least a digit is required."
        case .missingSpecialChars: return "At least a special character is required."
        case .minLength(let length): return "At least \(length) characters are required."
        }
    }
}

extension Form.Email: LocalizedError {
    public var errorDescription:String? {
        
        switch self {
        case .missing: return "The email address is required."
        case .invalid(let email): return "Your email address '\(email)' is invalid."
        }
    }
}

extension Form.Age: LocalizedError {
    public var errorDescription:String? {
        
        switch self {
        case .underage: return "You're underaged to use this service."
        }
    }
}
