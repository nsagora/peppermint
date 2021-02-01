import Foundation

public extension Result {
    /**
     The summary of a validation result.
     */
    struct Summary {
        
        /**
         `[Error]` if the validation result is `.failure`, `nil` otherwise.
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
        
        internal init(evaluationResults: [Result]) {
            let errors = evaluationResults
                .filter { $0.isFailed }
                .reduce(into: [Error]()) { $0 += $1.summary.errors }
            
            self.init(errors: errors)
        }
    }
}


// MARK: - Equatable conformance

extension Result.Summary: Equatable {
    
    public static func ==(lhs: Result.Summary, rhs: Result.Summary) -> Bool {
        return lhs.errors.map { $0.localizedDescription } == rhs.errors.map { $0.localizedDescription }
    }
}

// MARK: - Factory methods

extension Result.Summary {
    internal static var successful = Result.Summary(errors: [])
}
