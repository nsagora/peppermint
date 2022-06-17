import Foundation

@resultBuilder
public struct ConstraintBuilder<T, E: Error> {

    public typealias Component = [AnyConstraint<T, E>]
    
    public static func buildExpression(_ expression: some Constraint<T, E>) -> Component {
        return [expression.erase()]
    }
    
    public static func buildEither(first component: Component) -> Component {
        return component
    }
    
    public static func buildEither(second component: Component) -> Component {
        return component
    }
    
    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? []
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Component {
        return component
    }
    
    public static func buildBlock(_ components: Component...) -> Component {
        return components.flatMap { $0 }
    }
    
    public static func buildArray(_ components: [Component]) -> Component {
        return components.flatMap { $0 }
    }
    
    public static func buildFinalResult(_ component: Component) -> Component {
        return component
    }
}
