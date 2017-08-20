import Foundation

class AsyncOperation<T>: Operation {
    
    enum State {
        case ready
        case executing
        case finished
        
        var keyPath: String {
            switch self {
            case .ready: return "isReady"
            case .executing: return "isExecuting"
            case .finished: return "isFinished"
            }
        }
    }
    
    private let constraint: AsyncConstraint<T>
    private let input: T
    var result: EvaluationResult?
    
    init(input:T, constraint: AsyncConstraint<T>) {
    
        self.input = input
        self.constraint = constraint
        super.init()
    }
    
    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        
        if (isCancelled) {
            state = .finished
        }
        else {
            state = .executing
            execute()
        }
    }
    
    func execute() {
        
        constraint.evaluate(with: input, queue: .main) { result in
            self.handle(result: result)
        }
    }
    
    func handle(result: EvaluationResult) {
        state = .finished
        self.result = result
    }
}
