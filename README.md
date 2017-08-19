# Validation Toolkit

[![badge-travis]][url-travis] [![badge-codecov]][url-codecov] [![badge-carthage]][url-carthage] [![badge-license]][url-license] [![badge-twitter]][url-twitter] [![version-badge]][url-validationtoolkit]

1. [Introduction](#introduction)
	- [Separation of concerns](#separation-of-concerns)
	- [All platforms availability](#all-platforms-availability)
	- [Open to extensibility](#open-to-extensibility)
2. [Requirements](#requirements)
3. [Installation](#installation)
	- [Carthage](#carthage)
	- [CocoaPods](#cocoapods)
	- [Swift Package Manager](#swift-package-manager)
	- [Manually](#manually)
4. [Usage Examples](#usage-examples)
	- [Predicates](#predicates)
	- [Constraints](#constraints)
	- [Constraint Sets](#constraint-sets)
6. [Contribute](#contribute)
7. [Meta](#meta)
	- [Credits and References](#credits-and-references)

## Introduction

`ValidationToolkit` is designed to be a lightweight framework specialised in user data validation, such as email format, input length or passwords matching.

At the core of this project are the following principles:

- Separation of concerns
- Availability on all platforms
- Open to extensibility

### Separation of concerns

Think of `ValidationToolkit` as to an adjustable wrench more than to a Swiss knife.
With this idea in mind, the toolkit is composed from a small set of protocols, classes and structs than can be easily used to fit your project needs.

### All platforms availability

Since validation can take place at many levels, `ValidationToolkit` was designed to support iOS, macOS, tvOS, watchOS and native Swift projects, such as server apps.

### Open to extensibility

Every project is uniq in it's challenges and it's great when we can focus on solving them instead on focusing on boilerplate tasks.
While `ValidationToolkit` is compact and offers all you need to build validation around your project needs, it also includes a set of common validations that most of the projects can benefit of.
This includes validation predicates for email, required fields, password matching, url and many more to come.

## Requirements
- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.1+
- Swift 3.0+

## Installation

### Carthage

You can use [Carthage][url-carthage] to install `ValidationToolkit` by adding it to your [`Cartfile`][url-carthage-cartfile]:

```
github "nsagora/validation-toolkit"
```

Run `carthage update` to build the framework and drag the built `ValidationToolkit.framework` into your Xcode project.

<details>
<summary>Setting up Carthage</summary>

[Carthage][url-carthage] is a decentralised dependency manager that builds your dependencies and provides you with binary frameworks.

You can install [Carthage][url-carthage] with [Homebrew][url-homebrew] using the following command:

```bash
$ brew update
$ brew install carthage
```

</details>

### CocoaPods

You can use [CocoaPods][url-cocoapods] to install `ValidationToolkit` by adding it to your [`Podfile`][url-cocoapods-podfile]:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'YOUR_TARGET_NAME' do
	pod 'ValidationToolkit'
end
```

Then, run the following command:

```bash
$ pod install
```

Note that this requires CocoaPods version 1.0.0, and your iOS deployment target to be at least 8.0.

<details>
<summary>Setting up CocoaPods</summary>

[CocoaPods][url-cocoapods] is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```
</details>

### Swift Package Manager

You can use the [Swift Package Manager][url-swift-package-manager] to install `ValidationToolkit` by adding it to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/nsagora/validation-toolkit", majorVersion: 1),
    ]
)
```

Note that the [Swift Package Manager][url-swift-package-manager] is still in early design and development, for more information checkout its [GitHub Page][url-swift-package-manager-github].

### Manually
To use this library in your project manually you may:

1. for Projects, just drag the `Sources` folder into the project tree
2. for Workspaces, include the whole `ValidationToolkit.xcodeproj`

## Usage example
For a comprehensive list of examples try the `ValidationToolikit.playground`:

1. Download the repository locally on your machine
2. Open `ValidationToolkit.workspace`
3. Build `ValidationToolkit iOS` target
4. Select the `ValidationToolkit` playgrounds from the Project navigator.

### Predicates

The `Predicate` represents the core `protocol` and has the role to `evaluate` if an input matches on a given validation condition.

At `ValidationToolkit`'s core we have the following two predicates, which allow developers to compose predicates specific to the project needs.

<details>
<summary>`RegexPredicate`</summary>

```swift
let predicate = RegexPredicate(expression: "^[a-z]$")
predicate.evaluate(with: "a") // returns true
predicate.evaluate(with: "5") // returns false
predicate.evaluate(with: "ab") // returns false
```
</details>

<details>
<summary>`BlockPredicate`</summary>

```swift
let pred = BlockPredicate<String> { $0.characters.count > 2 }
predicate.evaluate(with: "a") // returns false
predicate.evaluate(with: "abc") // returns true
```
</details>

In addition, the toolkit offers a set of common validation predicates that your project can benefit of:

<details>
<summary>`EmailPredicate`</summary>

```swift
let predicate = EmailPredicate()
predicate.evaluate(with: "hello@") // returns false
predicate.evaluate(with: "hello@nsagora.com") // returns true
predicate.evaluate(with: "héllo@nsagora.com") // returns true
```
</details>

<details>
<summary>`URLPredicate`</summary>

```swift
let predicate = URLPredicate()
predicate.evaluate(with: "http://www.url.com") // returns true
predicate.evaluate(with: "http:\\www.url.com") // returns false
```
</details>

<details>
<summary>`PairMatchingPredicate`</summary>

```swift
let predicate = PairMatchingPredicate()
predicate.evaluate(with: ("swift", "swift")) // returns true
predicate.evaluate(with: ("swift", "obj-c")) // returns false
```
</details>

On top of that, developers can build more advanced or complex predicates by extending the `Predicate` protocol, and/ or by composing or decorating the existing predicates:

<details>
<summary>Custom Predicate</summary>

```swift
public class MinLenghtPredicate: Predicate {

    public typealias InputType = String

    private let minLenght:Int

    public init(minLenght:Int) {
        self.minLenght = minLenght
    }

    public func evaluate(with input: String) -> Bool {
        return input.characters.count >= minLenght
    }
}

let predicate = MinLenghtPredicate(minLenght: 5)
predicate.evaluate(with: "alph") // returns false
predicate.evaluate(with: "alpha") // returns true
predicate.evaluate(with: "alphabet") // returns true
```
</details>

### Constraints

A `Constraint` represents a structure that links a `Predicate` to an `Error`, in order to provide useful feedback for the end users.

<details>
<summary>`Constraint` Example</summary>

```swift
let predicate = BlockPredicate<String> { $0 == "Mr. Goodbytes" }
let constraint = Constraint(predicate: predicate, error: MyError.magicWord)

let result = constraint.evaluate(with: "please")
switch result {
case .valid:
    print("access granted...")
case .invalid(let error as MyError):
    print(error.errorDescription)
}
```

```swift
enum MyError:Error {
    case magicWord
}

extension MyError: LocalizedError {
    var errorDescription:String? {
        return "Ah Ah Ah! You didn't say the magic word!"
    }
}
```
</details>

### Constraint Sets

A `ConstraintSet` represents a collection of constraints that allows the evaluation to be made on:

- any of the constraints
- all constraints

To provide context, a `ConstraintSet` allows us to constraint an input as being required and also as being a valid email.

<details>
<summary>`ConstraintSet` Example</summary>

The classic validation example is that of the login form, whereby users are prompted to enter their *username* and *password*. This process typically entails some form of validation, but the logic itself is often unstructured and spread out through a view controller. Similarly, the logic is often invoked through various user interactions (e.g. typing characters into a field, and tapping a *Login* button).

`ValidationToolkit` seeks instead to consolidate, standardise, and make explicit the logic that is being used to validate user input. To this end, the below example demonstrates construction of a full `ConstraintSet` object that can be used to enforce requirements on the username input data:

```swift

// Setup a `Constraint` used to check the length of the username
let usernameLengthConstraint = { () -> Constraint<String> in
    let pred = BlockPredicate<String> { $0.characters.count > 2 }
    return Constraint(predicate: pred, error: FormError.UserName.tooShort)
}()

// Setup a `Constraint` used to check the characters contained within the username
let usernameCharactersConstraint = { () -> Constraint<String> in
    let pred = RegexPredicate(expression: "^[0-9a-Z_\\-]*?$")
    return Constraint<String>(predicate: pred, error: FormError.UserName.invalidCharacters)
}()

// Create our `ConstraintSet` to compose the two constraints
let usernameConstraints = [usernameLengthConstraint, usernameCharactersConstraint];
let usernameValidator = ConstraintSet<String>(constraints: usernameConstraints)

// Evaluate user input, and collect results
let results = usernameValidator.evaluateAll(input: "nsagora")
let errorMessages = results.flatMap { result -> String? in
    switch result {
    case .valid:
        return nil
    case .invalid(let error):
        return error.localizedDescription
    }
}

print(errorMessages)
```

```swift
// Define form errors

enum FormError {

    enum UserName:Error {
        case tooShort
        case invalidCharacters
    }
}

extension FormError.UserName: LocalizedError {

    var errorDescription:String? {
        switch self {
        case .tooShort:
            return "Username must be at least 3 characters long."
        case .invalidCharacters:
            return "Username must only contain alphanumeric characters, dashes, and underscores."
        }
    }
}
```

From above, we see that once we've constructed the `usernameValidator`, we're simply calling `evaluateAll(input:)` to get a list of results. These results we can then map into an array of error messages, which we can handle as we please. You can imagine that we might construct this `usernameValidator` once, and simply evaluate it against the user input data when we want to perform validation on the username.
</details>

## Contribute

We would love you for the contribution to **ValidationToolkit**, check the [``LICENSE``][url-license-file] file for more info.

## Meta

This project is developed and maintained by the members of [iOS NSAgora][url-twitter], the community of iOS Developers of Iași, Romania.

Distributed under the [MIT][url-license] license. See [``LICENSE``][url-license-file] for more information.

[https://github.com/nsagora/validation-toolkit]

### Credits and references

We got inspired from other open source projects and they worth to be mentioned below for reference:

- https://github.com/adamwaite/Validator
- https://github.com/jpotts18/SwiftValidator

[url-validationtoolkit]: https://github.com/nsagora/validation-toolkit

[url-carthage]: https://github.com/Carthage/Carthage
[url-carthage-cartfile]: https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile

[url-cocoapods]: https://cocoapods.org
[url-cocoapods-podfile]: https://guides.cocoapods.org/syntax/podfile.html

[url-swift-package-manager]: https://swift.org/package-manager
[url-swift-package-manager-github]: https://github.com/apple/swift-package-manager

[url-license]: http://choosealicense.com/licenses/mit/
[url-license-file]: https://github.com/nsagora/validation-toolkit/blob/master/LICENSE
[url-twitter]: https://twitter.com/nsagora
[url-travis]: https://travis-ci.org/nsagora/validation-toolkit
[url-codecov]: https://codecov.io/gh/nsagora/validation-toolkit
[url-homebrew]: http://brew.sh/

[badge-license]: https://img.shields.io/badge/license-MIT-blue.svg?style=flat
[badge-twitter]: https://img.shields.io/badge/twitter-%40nsgaora-blue.svg?style=flat
[badge-travis]: https://travis-ci.org/nsagora/validation-toolkit.svg?branch=develop
[badge-codecov]: https://codecov.io/gh/nsagora/validation-toolkit/branch/develop/graph/badge.svg
[badge-carthage]: https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat
[version-badge]: https://img.shields.io/badge/version-0.5.0-blue.svg?style=flat


