__Validation Toolkit__ · [Validation Components][validation-components]

[validation-toolkit]: https://github.com/nsagora/validation-toolkit
[validation-components]: https://github.com/nsagora/validation-components 

-------

# Validation Toolkit

[![travis-status]][travis-overview] [![codecov-status]][codecov-overview] [![carthage-compatible]][carthage-overview] [![license]][license-overview] [![twitter]][twitter-overview]

[license]: https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg?style=flat
[license-overview]: http://choosealicense.com/licenses/apache-2.0/

[twitter]: https://img.shields.io/badge/twitter-%40nsgaora-blue.svg?style=flat
[twitter-overview]: https://twitter.com/nsagora

[travis-status]: https://travis-ci.org/nsagora/validation-toolkit.svg?branch=develop
[travis-overview]: https://travis-ci.org/nsagora/validation-toolkit

[codecov-status]: https://codecov.io/gh/nsagora/validation-toolkit/branch/develop/graph/badge.svg
[codecov-overview]: https://codecov.io/gh/nsagora/validation-toolkit 

[carthage-compatible]: https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat
[carthage-overview]: https://github.com/Carthage/Carthage

## Introduction

`Validation Toolkit` is designed to be a lightweight framework specialised in user data validation, such as email format, input length or passwords matching.

At the core of this project are the following principles:

- Separation of concerns
- Availability on all platforms 
- Open to extensibility

### Separation of concerns

Think of `Validation Toolkit` as to an adjustable wrench more than to a Swiss knife. 
With this idea in mind, the kit is composed from a small set of protocols, classes and structs than can be easily used to fit your project needs.

### All platforms availability

Since validation can take place at many levels, Validation Toolkit was designed to support iOS, macOS, tvOS, watchOS and native swift projects, such as server apps.

### Open to extensibility

Every project is uniq in it's challenges and it's great when we can focus on solving them instead on focusing on boiler plate tasks. 
While Validation Toolkit is compact and offers all you need to build validation around your project needs, we created `Validation Components` to extends it by adding the common validations that most of the projects can benefits of.
This includes validation predicates for email, required fields, password matching, url and many other.     

## Installation

### Carthage

The full documentation on how to install and use [Carthage][carthage] is available on their official github [page][carthage].

To use the latest stable version, add this to your [`Cartfile`][carthage-cartfile]:

``` 
github "nsagora/validation-toolkit" 
```

To use a certain version, add this to your [`Cartfile`][carthage-cartfile]:

``` 
github "nsagora/validation-toolkit" >= 0.1.0 
```

To use the latest version in development, add this to your [`Cartfile`][carthage-cartfile]:

``` 
github "nsagora/validation-toolkit" "develop" 
```

[carthage]: https://github.com/Carthage/Carthage
[carthage-cartfile]: https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile

## Concepts

### ValidationPredicate

The `ValidationPredicate` represents the core `protocol` and has the role to `evaluate` if an input matches on a given predicate.

Out of the box, `ValidationToolkit` brings the following predicates, which allow the developers to construct their specific predicates:
- `RegexValidationPredicate`
- `BlockValidationPredicate`

For more advanced or complex predicates the developers can extend the `ValidationPredicate` to fit the project needs.

### ValidationConstraint

A `ValidationConstraint` represents a structure that link a `ValidationPredicate` with a custom message, useful for user feedback.

### Validator

A `Validator` represents a collection of constraints and allows the evaluation to be made on:
- any of the constraints
- all constraints

To provide context, a `Validator` allows to constrain an input as being required and as being a valid email.

## Examples

### Full Validator Example

The classic validation example is that of the login form, whereby users are prompted to enter their *username* and *password*. This process typically entails some form of validation, but the logic itself is often unstructured and spread out through a view controller. Similarly, the logic is often invoked through various user interactions (e.g. typing characters into a field, and tapping a *Login* button).

`Validation Toolkit` seeks instead to consolidate, standardize, and make explicit the logic that is being used to validate user input. To this end, the below example demonstrates construction of a full `Validator` object that can be used to enforce requirements on the username input data:

```swift
// Setup a constraint used to check the length of the username
let usernameLengthConstraint = { () -> ValidationConstraint<String> in
    let pred = BlockValidationPredicate<String> {
        ($0 ?? "").characters.count > 2
    }
    let msg = "Username must be at least 3 characters long."
    return ValidationConstraint(predicate: pred, message: msg)
}()

// Setup a constraint used to check the characters contained within the username
let usernameCharactersConstraint = { () -> ValidationConstraint<String> in 
    let pred = RegexValidationPredicate(expression: "^[0-9a-Z_\\-]*?$")
    let msg = "Username must only contain alphanumeric characters, dashes, and underscores."
    return ValidationConstraint<String>(predicate: pred, message: msg)
}()

// Create our validator to compose the two constraints
let usernameConstraints = [usernameLengthConstraint, usernameCharactersConstraint];
let usernameValidator = Validator<String>(constraints: usernameConstraints)

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

From above, we see that once we've constructed the `usernameValidator`, we're simply calling `evaluateAll(input:)` to get a list of results. These results we can then map into an array of error messages, which we can handle as we please. You can imagine that we might construct this `usernameValidator` once, and simply evaluate it against the user input data when we want to perform validation on the username.

### Independent Components

Along with the fully integrated scenario depicted above, `Validator Kit` also supports using each component independently. Specifically, we are able to exercise a `ValidationPredicate` outside of a `ValidationConstraint`, and similarly exercise a `ValidationConstraint` outside of a `Validator`.

**ValidationPredicate**

```swift
let predicate = RegexValidationPredicate(expression: "^[a-z]$")
predicate.evaluate(with: "a") // returns true
predicate.evaluate(with: "5") // returns false
predicate.evaluate(with: "ab") // returns false
```

**ValidationConstraint**

```swift
let predicate = BlockValidationPredicate<String> { $0 == "Mr. Goodbytes" }
let message = "Ah Ah Ah! You didn't say the magic word!"
let constraint = ValidationConstraint(predicate: predicate, message: message)

let result = constraint.evaluate(with: "please")
switch result {
    case .valid:
        print("access granted...")
    case .invalid(let error):
        print(error.localizedDescription) // prints the message
}
```

## Credits and references

The project was been inspired from other open source projects and they worth to be mentioned below for reference:

- https://github.com/adamwaite/Validator
- https://github.com/jpotts18/SwiftValidator
