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
With this idea in mind, the toolkit is composed from a small set of protocols, classes and structs than can be easily used to fit your project needs.

### All platforms availability

Since validation can take place at many levels, Validation Toolkit was designed to support iOS, macOS, tvOS, watchOS and native Swift projects, such as server apps.

### Open to extensibility

Every project is uniq in it's challenges and it's great when we can focus on solving them instead on focusing on boilerplate tasks. 
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

### Predicates

The `Predicate` represents the core `protocol` and has the role to `evaluate` if an input matches on a given validation predicate.

Out of the box, `ValidationToolkit` brings the following predicates, which allow developers to build more specific predicates:
- `RegexPredicate`
- `BlockPredicate`

For more advanced or complex predicates the developers can extend the `Predicate` protocol to fit the project needs.

### Constraints

A `Constraint` represents a structure that links a `Predicate` to an `Error`, in order to provide useful feedback for the end users.

### Constraint Sets

A `ConstraintSet` represents a collection of constraints and allows the evaluation to be made on:
- any of the constraints
- all constraints

To provide context, a `ConstraintSet` allows us to constraint an input as being required and also as being a valid email.

## Examples

### Full Validatotion Example

The classic validation example is that of the login form, whereby users are prompted to enter their *username* and *password*. This process typically entails some form of validation, but the logic itself is often unstructured and spread out through a view controller. Similarly, the logic is often invoked through various user interactions (e.g. typing characters into a field, and tapping a *Login* button).

`Validation Toolkit` seeks instead to consolidate, standardize, and make explicit the logic that is being used to validate user input. To this end, the below example demonstrates construction of a full `ConstraintSet` object that can be used to enforce requirements on the username input data:

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

### Independent Components

Along with the fully integrated scenario depicted above, `Validator Kit` also supports using each component independently. Specifically, we are able to exercise a `Predicate` outside of a `Constraint`, and similarly exercise a `Constraint` outside of a `Constraints`.

**Predicates**

```swift
let predicate = RegexPredicate(expression: "^[a-z]$")
predicate.evaluate(with: "a") // returns true
predicate.evaluate(with: "5") // returns false
predicate.evaluate(with: "ab") // returns false
```

**Constraints**

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
## Credits and references

The project was been inspired from other open source projects and they worth to be mentioned below for reference:

- https://github.com/adamwaite/Validator
- https://github.com/jpotts18/SwiftValidator
