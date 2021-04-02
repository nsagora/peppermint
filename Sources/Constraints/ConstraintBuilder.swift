import Foundation

@resultBuilder
public struct ConstraintBuilder<T, E: Error> {
    
    static func buildBlock(_ components: ContainerConstraint<T, E>...) -> ContainerConstraint<T, E> {
        return ContainerConstraint.flatMap(containers: components)
    }
    
    static func buildArray(_ components: [ContainerConstraint<T, E>]) -> ContainerConstraint<T, E> {
        return ContainerConstraint.flatMap(containers: components)
    }
    
    static func buildExpression<C: Constraint>(_ expression: C) -> ContainerConstraint<T, E> where C.InputType == T, C.ErrorType == E {
        return ContainerConstraint(expression)
    }
    
    static func buildEither(first component: ContainerConstraint<T, E>) -> ContainerConstraint<T, E> {
        return component
    }
    
    static func buildEither(second component: ContainerConstraint<T, E>) -> ContainerConstraint<T, E> {
        return component
    }
    
    static func buildOptional(_ component: ContainerConstraint<T, E>?) -> ContainerConstraint<T, E> {
        return component ?? ContainerConstraint()
    }
    
    static func buildLimitedAvailability(_ component: ContainerConstraint<T, E>) -> AnyConstraint<T, E> {
        return component.erase()
    }
    
    static func buildFinalResult(_ component: ContainerConstraint<T, E>) -> [AnyConstraint<T, E>] {
        return component.constraints
    }
}

extension ConstraintBuilder {
    
    struct ContainerConstraint<T, E: Error>: Constraint {
        
        private(set) var constraints = [AnyConstraint<T, E>]()
        
        init(){ }
        
        init<C: Constraint>(_ constraints: [C]) where C.InputType == T, C.ErrorType == E {
            self.constraints = constraints.map { $0.erase() }
        }
        
        init<C: Constraint>(_ constraints: C...) where C.InputType == T, C.ErrorType == E {
            self.constraints = constraints.map { $0.erase() }
        }
        
        func evaluate(with input: T) -> Result<Void, Summary<E>> {
            fatalError()
        }
        
        static func flatMap(containers:  [ContainerConstraint] = []) -> ContainerConstraint {
            let constraints = containers.reduce([]) { $0 + $1.constraints }
            return ContainerConstraint(constraints)
        }
    }
}
