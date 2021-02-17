import Foundation

protocol FakeableError: Error, Equatable { }

extension Error {
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.localizedDescription == rhs.localizedDescription)
    }
}
