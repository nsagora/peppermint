import Foundation

extension Result {

    internal init(summary:Summary) {

        if summary.errors.count == 0 {
            self = .valid
        }
        else {
            self = .invalid(summary)
        }
    }

    /**
     The summary of a validation result.
     */
    public struct Summary {

        /**
         `[Error]` if the validation result is `.invalid`, `nil` otherwise.
         */
        public private(set) var errors = [Error]()

        /**
         The number of failing constraints for a `.invalid` result, `0` otherwise.
         */
        public var failingConstraints: Int {
            return errors.count
        }

        /**
         `true` if the validation result is `.invalid`, `false` otherwise.
         */
        public var hasFailingContraints: Bool {
            return failingConstraints > 0
        }

        internal init(errors:[Error]) {
            self.errors = errors;
        }

        internal init(evaluationResults:[Result]) {

            var errors = [Error]()
            for result in evaluationResults {
                switch result {
                case .invalid(let summary):
                    errors.append(contentsOf: summary.errors)
                default:
                    continue
                }
            }

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
    internal static var Successful = Result.Summary(errors: [])
}
