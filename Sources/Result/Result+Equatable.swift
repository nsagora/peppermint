import Foundation

extension Result: Equatable {

    public static func ==(lhs: Result, rhs: Result) -> Bool {
        switch (rhs, lhs) {
        case (.valid, .valid): return true
        case (.invalid(let a), .invalid(let b)): return a == b
        default: return false
        }
    }
}
