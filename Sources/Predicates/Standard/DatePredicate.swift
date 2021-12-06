import Foundation

public struct DatePredicate: Predicate {
    
    public typealias InputType = String
    
    private let dateFormatter: DateFormatter
    
    public init(formatter: DateFormatter) {
        self.dateFormatter = formatter
    }
    
    public func evaluate(with input: String) -> Bool {
        if let _ = dateFormatter.date(from: input) {
            return true
        }
        return false
    }
    
}
