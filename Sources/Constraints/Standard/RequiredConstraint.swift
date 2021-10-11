import Foundation

public struct RequiredConstraint<T: Collection, E: Error>: Constraint {
    
    private let predicate = RequiredPredicate<T>()
    private let errorBuilder: (T) -> E
    
    public init(error: E) {
        self.errorBuilder = { _ in return error }
    }
   
    public init(errorBuilder: @escaping (T) -> E) {
        self.errorBuilder = errorBuilder
    }
    
    public init(errorBuilder: @escaping () -> E) {
        self.errorBuilder = { _ in return errorBuilder() }
    }
    
    
    public func evaluate(with input: T) -> Result<Void, Summary<E>> {
        let result = predicate.evaluate(with: input)
        if result {
            return .success(())
        }
        
        let error = errorBuilder(input)
        let summary = Summary(errors: [error])
        return .failure(summary)
    }
}
