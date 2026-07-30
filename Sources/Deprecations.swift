import Foundation

// MARK: - Predicate → Rule deprecation bridges
// These typealiases preserve source compatibility for existing code during
// a transition window. They will be removed in the next major version.

@available(*, deprecated, renamed: "Rule")
public typealias Predicate = Rule

@available(*, deprecated, renamed: "AnyRule")
public typealias AnyPredicate<T> = AnyRule<T>

@available(*, deprecated, renamed: "BlockRule")
public typealias BlockPredicate<T> = BlockRule<T>

@available(*, deprecated, renamed: "RegexRule")
public typealias RegexPredicate = RegexRule

@available(*, deprecated, renamed: "EmailRule")
public typealias EmailPredicate = EmailRule

@available(*, deprecated, renamed: "URLRule")
public typealias URLPredicate = URLRule

@available(*, deprecated, renamed: "LengthRule")
public typealias LengthPredicate<T: Collection> = LengthRule<T>

@available(*, deprecated, renamed: "RangeRule")
public typealias RangePredicate<T: Comparable> = RangeRule<T>

@available(*, deprecated, renamed: "DateRule")
public typealias DatePredicate = DateRule

@available(*, deprecated, renamed: "CharacterSetRule")
public typealias CharacterSetPredicate = CharacterSetRule

@available(*, deprecated, renamed: "RequiredRule")
public typealias RequiredPredicate<T: Collection> = RequiredRule<T>

@available(*, deprecated, renamed: "RuleConstraint")
public typealias PredicateConstraint<T, E: Error> = RuleConstraint<T, E>
