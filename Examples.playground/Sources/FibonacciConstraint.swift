import Foundation
import Peppermint

public struct FibonnaciConstraint<E: Error>: Constraint {
    
    public typealias InputType = Int
    public typealias ErrorType = E
    
    private let error: E
    
    public init(with error: E) {
        self.error = error
    }
    
    public func evaluate(with input: Int) -> Result<Void, Summary<E>> {
        if isFibonacciNumber(input: input) {
            return .success
        }
        return .failure([error])
    }
}

func isFibonacciNumber(input: Int) -> Bool {
    var i = 0
    var fib = 0
    repeat {
        if fib == input {
            return true
        }
        fib = fibonacci(of: i)
        i += 1
    } while fib <= input
    return false
}

func fibonacci(of value:Int) -> Int {
    
    if value == 0 {
        return 0
    }
    
    if value == 1 {
        return 1
    }
    
    return fibonacci(of: value-1) + fibonacci(of: value-2)
}
