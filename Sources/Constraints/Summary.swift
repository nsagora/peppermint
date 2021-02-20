import Foundation

/**
 The summary of a validation result.
 */
public struct Summary: Error {
    
    /**
     A non-empty`[Error]` if the validation result is `.failure`, empty otherwise.
     */
    public private(set) var errors = [Error]()
    
    /**
     The number of failing constraints for a `.failure` result, `0` otherwise.
     */
    public var failingConstraints: Int { errors.count }
    
    /**
     `true` if the validation result is `.failure`, `false` otherwise.
     */
    public var hasFailingContraints: Bool { failingConstraints > 0 }
    
    internal init(errors: [Error]) {
        self.errors = errors
    }
    
    internal init(evaluationResults: [Result<Void, Summary>]) {
        let errors = evaluationResults
            .filter { $0.isFailure }
            .reduce(into: [Error]()) { $0 += $1.summary.errors }
        
        self.init(errors: errors)
    }
}


// MARK: - Equatable conformance

extension Summary: Equatable {
    
    public static func ==(lhs: Summary, rhs: Summary) -> Bool {
        return lhs.errors.map { $0.localizedDescription } == rhs.errors.map { $0.localizedDescription }
    }
}

// MARK: - Factory methods

extension Summary {
    internal static var successful: Summary { Summary(errors: [])}
}
