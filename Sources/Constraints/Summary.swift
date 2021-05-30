import Foundation

/**
 The summary of a validation result.
 */
public struct Summary<E>: Error where E: Error {
    
    /**
     A non-empty`[Error]` if the validation result is `.failure`, empty otherwise.
     */
    public private(set) var errors = [E]()
    
    /**
     The number of failing constraints for a `.failure` result, `0` otherwise.
     */
    public var failingConstraints: Int { errors.count }
    
    /**
     `true` if the validation result is `.failure`, `false` otherwise.
     */
    public var hasFailingConstraints: Bool { failingConstraints > 0 }
    
    internal init(errors: [E]) {
        self.errors = errors
    }
}


// MARK: - Equatable conformance

extension Summary: Equatable {
    
    public static func ==(lhs: Summary, rhs: Summary) -> Bool {
        return lhs.errors.map { $0.localizedDescription } == rhs.errors.map { $0.localizedDescription }
    }
}
