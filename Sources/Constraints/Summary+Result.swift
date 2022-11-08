import Foundation

public extension Result where Success == Void {
    
    /// A successful evaluation `Result`
    static var success: Result<Success, Failure> {
        .success(())
    }
    
    /// A failed evaluation `Result` containing the `Summary` with the provided `Error`
    static func failure<E: Error>(_ errors: [E]) -> Result<Success, Summary<E>> {
        .failure(Summary(errors: errors))
    }
    
    /// A failed evaluation `Result` containing the `Summary` with the provided `Error`
    static func failure<E: Error>(_ errors: E...) -> Result<Success, Summary<E>> {
        .failure(errors)
    }
}
