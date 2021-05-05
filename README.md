# Peppermint [![badge-version]][url-peppermint]

[![badge-build-macos]][url-peppermint]
[![badge-build-linux]][url-peppermint]
[![badge-codecov]][url-codecov]
[![badge-docs]][url-peppermint-docs]
[![badge-license]][url-license]
[![badge-twitter]][url-twitter]

1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Installation](#installation)
   - [Swift Package Manager](#swift-package-manager)
4. [Usage Examples](#usage-examples)
   - [Predicates](#predicates)
   - [Constraints](#constraints)
   - [Predicate Constraint](#predicate-constraint)
   - [Compound Constraint](#compound-constraint)
5. [Contribute](#contribute)
6. [Meta](#meta)

## Introduction
 
`Peppermint` is a declarative and lightweight data validation framework.

At the core of it, there are 2 principles:

- Empower composition.
- Embrace standard library.

Every project is unique in it's own challenges and it's great when we can focus on solving them instead of spending our time on boilerplate tasks.

With this idea in mind, the framework follows the Protocol Oriented Programming paradigm and was designed from a small set of protocols and structures that can easily be composed to fit your project needs. Thus, you can think of `Peppermint` as an adjustable wrench more than a Swiss knife.

Since validation can take place at many levels, `Peppermint` is available on iOS, macOS, tvOS, watchOS and native Swift projects, such as server-side apps.

## Requirements

- Swift 4.2+
- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.1+

## Installation

`Peppermint` is available only through Swift Package Manager.

### Swift Package Manager

You can add `Peppermint` to your project [in Xcode][url-swift-package-manager] by going to  `File > Swift Packages > Add Package Dependency`.

Or, if you want to use it as a dependency to your own package, you can add it to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/nsagora/peppermint", majorVersion: 1),
    ]
)
```

## Usage example

For a comprehensive list of examples try out the `Examples.playground`:

1. Download the repository locally on your machine
2. Open the project in Xcode
4. Select the `Examples` playground from the Project navigator

The `Peppermint` framework is compact and offers you the foundation you need to build data validation around your project needs. In addition, it includes a set of common validation predicates and constraints that most projects can benefit of.

### Predicates

The `Predicate` represents the core `protocol` and has the role to `evaluate` if an input matches on a given validation condition.

At the core of `Peppermint` there are the following two predicates, which allows you to compose predicates specific to the project needs:

<details>
<summary>BlockPredicate</summary>

```swift
let predicate = BlockPredicate<String> { $0.characters.count > 2 }
predicate.evaluate(with: "a") // returns false
predicate.evaluate(with: "abc") // returns true
```
</details>

<details>
<summary>RegexPredicate</summary>

```swift
let predicate = RegexPredicate(expression: "^[a-z]$")
predicate.evaluate(with: "a") // returns true
predicate.evaluate(with: "5") // returns false
predicate.evaluate(with: "ab") // returns false
```
</details>

In addition, the framework offers a set of common validation predicates that your project can benefit of:

<details>
<summary>EmailPredicate</summary>

```swift
let predicate = EmailPredicate()
predicate.evaluate(with: "hello@") // returns false
predicate.evaluate(with: "hello@nsagora.com") // returns true
predicate.evaluate(with: "héllo@nsagora.com") // returns true
```
</details>

<details>
<summary>URLPredicate</summary>

```swift
let predicate = URLPredicate()
predicate.evaluate(with: "http://www.url.com") // returns true
predicate.evaluate(with: "http:\\www.url.com") // returns false
```
</details>

<details>
<summary>RangePredicate</summary>

```swift
let predicate = let range = RangePredicate(10...20)
predicate.evaluate(with: 15) // returns true
predicate.evaluate(with: 21) // returns false
```
</details>

<details>
<summary>LengthPredicate</summary>

```swift
let predicate = let range = LengthPredicate<String>(min: 5)
predicate.evaluate(with: "abcde")   // returns true
predicate.evaluate(with: "abcd")    // returns false
```
</details>

On top of that, developers can build more advanced or complex predicates by extending the `Predicate` protocol, and/ or by composing or decorating the existing predicates:

<details>
<summary>Custom Predicate</summary>

```swift
public struct CustomPredicate: Predicate {

    public typealias InputType = String

    private let custom: String

    public init(custom: String) {
        self.custom = custom
    }

    public func evaluate(with input: String) -> Bool {
        return input == custom
    }
}

let predicate = CustomPredicate(custom: "alphabet")
predicate.evaluate(with: "alp") // returns false
predicate.evaluate(with: "alpha") // returns false
predicate.evaluate(with: "alphabet") // returns true
```

</details>

### Constraints

#### Predicate Constraint

A `PredicateConstraint` represents a data type that links a `Predicate` to an `Error`, in order to provide useful feedback for the end users.

<details>
<summary>PredicateConstraint</summary>

```swift
let predicate = BlockPredicate<String> { $0 == "Mr. Goodbytes" }
let constraint = PredicateConstraint(predicate: predicate, error: MyError.magicWord)

let result = constraint.evaluate(with: "please")
switch result {
case .valid:
    print("access granted...")
case .invalid(let summary):
    print("Ah Ah Ah! You didn't say the magic word!")
}  // prints "Ah Ah Ah! You didn't say the magic word!"
```

```swift
enum MyError: Error {
    case magicWord
}
```

</details>

#### Compound Constraint

A `CompoundConstraint` represents a composition of constraints that allows the evaluation to be made on:

- any of the constraints
- all constraints

To provide context, a `CompoundConstraint` allows us to constraint a piece of data as being required and also as being a valid email.

<details>
<summary>CompoundConstraint</summary

An example of a  registration form, whereby users are prompted to enter a strong _password_. This process typically entails some form of validation, but the logic itself is often unstructured and spread out through a view controller.

`Peppermint` seeks instead to consolidate, standardise, and make explicit the logic that is being used to validate user input. To this end, the below example demonstrates construction of a full `CompoundContraint` object that can be used to enforce requirements on the user's password data:

```swift
var passwordConstraint = CompoundContraint<String, Form.Password>.allOf(
    PredicateConstraint {
        CharacterSetPredicate(.lowercaseLetters, mode: .loose)
    } errorBuilder: {
        .missingLowercase
    },
    PredicateConstraint{
        CharacterSetPredicate(.uppercaseLetters, mode: .loose)
    } errorBuilder: {
        .missingUppercase
    },
    PredicateConstraint {
        CharacterSetPredicate(.decimalDigits, mode: .loose)
    } errorBuilder: {
        .missingDigits
    },
    PredicateConstraint {
        CharacterSetPredicate(CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-="), mode: .loose)
    } errorBuilder: {
        .missingSpecialChars
    },
    PredicateConstraint {
        LengthPredicate(min: 8)
    }  errorBuilder: {
        .minLength(8)
    }
)

let password = "3nGuard!"
let result = passwordConstraint.evaluate(with: password)

switch result {
case .success:
    print("Wow, that's a 💪 password!")
case .failure(let summary):
    print(summary.errors.map({$0.localizedDescription}))
} // prints "Wow, that's a 💪 password!"
```

From above, we see that once we've constructed the `passwordConstraint`, we're simply calling `evaluate(with:)` to get our evaluation `Result`. This contains a `Summary` that can be handled as we please.

</details>

## Contribute

We would love you for the contribution to **Peppermint**, check the [`LICENSE`][url-license-file] file for more info.

## Meta

This project is developed and maintained by the members of [iOS NSAgora][url-twitter], the community of iOS Developers of Iași, Romania.

Distributed under the [MIT][url-license] license. See [`LICENSE`][url-license-file] for more information.

[https://github.com/nsagora/peppermint]

[url-peppermint]: https://github.com/nsagora/peppermint
[url-peppermint-docs]: https://nsagora.github.io/peppermint/
[url-swift-package-manager]: https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app
[url-license]: http://choosealicense.com/licenses/mit/
[url-license-file]: https://github.com/nsagora/peppermint/blob/master/LICENSE
[url-twitter]: https://twitter.com/nsagora
[url-codecov]: https://codecov.io/gh/nsagora/peppermint
[badge-license]: https://img.shields.io/badge/license-MIT-blue.svg?style=flat
[badge-twitter]: https://img.shields.io/badge/twitter-%40nsgaora-blue.svg?style=flat
[badge-build-macos]: https://github.com/nsagora/peppermint/actions/workflows/build-macos.yml/badge.svg
[badge-build-linux]: https://github.com/nsagora/peppermint/actions/workflows/build-linux.yml/badge.svg
[badge-codecov]: https://codecov.io/gh/nsagora/peppermint/branch/develop/graph/badge.svg
[badge-version]: https://img.shields.io/badge/version-0.8-blue.svg?style=flat
[badge-docs]: https://img.shields.io/badge/docs-95%25-brightgreen.svg?style=flat
